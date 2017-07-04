#!/usr/bin/env ruby

# file: mtlite.rb

require 'rdiscount'
require 'embiggen'

class MTLite
  
  def initialize(raw_msg)

    # reveal the expanded URL from a shortened URL
    raw_msg.gsub!(/https?:\/\/[\w\-_\.\/?+&]+/) do |url|      
      Embiggen::URI(url).expand.to_s
    end
    
    # make the smartlinks into Markdown links        
    @raw_msg = smartlink(raw_msg)
    
  end

  def to_html(para: false, ignore_domainlabel: false)

    raw_msg = @raw_msg.clone    
    # if it looks like an MtLite list make it an MtLite list
    # e.g. "a todo list:\n* line 1\n* line 2" => 
    #                                       a todo list: [* line 1 * line 2]
    raw_msg.sub!(/^(?:[\*#][^\n]+\n?)+/,'[\0]') if raw_msg =~ /\n/
    raw_msg.gsub!(/\n/,' ')


    # add br tags to checklist items
    # todo list: [[x] line 1 [] line 2] => 
    #                         todo list: <br/>[x] line 1 <br/>[] line 2
    raw_msg.sub!(/\[\[.*\]/){|x| x[0..-2].gsub(/[^\n](\[[x\s]?\])/,'<br/>\1') }

    # convert square brackets to unicode check boxes
    # replaces a [] with a unicode checkbox, 
    #                         and [x] with a unicode checked checkbox
    raw_msg = raw_msg.gsub(/\[\s*\](?= )/,'&#9744;').gsub(/\[x\]/,'&#9745;')

    # convert fractions using their associated unicode character
    # i.e. 1/4, 1/2, 3/4 
    raw_msg = raw_msg.gsub('\b1/4\b','&#188;').gsub('\b1/2\b','&#189;')\
                    .gsub('\b3/4\b','&#190;')

    # add strikethru to completed items
    # e.g. -milk cow- becomes <del>milk cow</del>
    raw_msg.gsub!(/\s-[^-]+-?[^-]+-[\s\]]/) do |x|
      x.sub(/-([&\w]+.*\w+)-/,'<del>\1</del>')
    end
      
    unless ignore_domainlabel then
      
      # append a domain label after the URL
      raw_msg.gsub!(/(?:^\[|\s\[)[^\]]+\]\((https?:\/\/[^\s]+)/) do |x|
        s2 = x[/https?:\/\/([^\/]+)/,1].split(/\./)
        r = s2.length >= 3 ? s2[1..-1] :  s2
        "%s [%s]" % [x, r.join('.')]
      end
      
    end
    
    # generate html lists from mtlite 1-liner lists
    raw_msg.gsub!(/\[[\*#][^\]]+\]/) do |list|

      if not list[/\n/] then

        symbol = list[1]
        symbol.prepend '\\' if symbol == '*'
        tag = {'#' => 'ol', '\*' => 'ul'}[symbol]

        "<#{tag}>%s</#{tag}>" % list.strip[1..-2].split(/#{symbol}/)[1..-1].
          map{|x| "<li>%s</li>" % x.strip}.join
      else
        list
      end

    end

    msg = RDiscount.new(raw_msg).to_html
    msg.gsub!(/<\/?p[^>]*>/,'') unless para

    regex = %r([\w\-/?=.#\(\)]+)
    # generate anchor tags for URLs which don't have anchor tags
    msg.gsub!(/(?:^(https?:#{regex})|\s(https?:#{regex}))/,' <a href="\2">\2</a>')    
    
    msg.gsub!(/(?:^(https?:#{regex})|\s(https?:#{regex}))/) do |x|
      url = $2
      url2 = url.sub(/^https?:\/\//,'').sub(/^www\./,'')
      url3 = url2.length > 33 ? url2[0..33] + '…' : url2
      " <a href='#{url}'>#{url3}</a>"
    end

    # add the target attribute to make all hyperlinks open in a new browser tab
    msg.gsub!(/<a /,'<a target="_blank" ')
    
    # undecorate h1 headings
    msg.gsub!(/<h1/,'<h1 style="font-size: 0.95em; font-weight: 600"')
        
    @msg = msg
    
  end
  
  def length
    @msg.gsub(/<\/?.[^>]*>/,'').length
  end
  
  def to_s
  
    msg = @raw_msg.clone
    
    # remove markdown hyperlink markings
    msg.gsub!(/\[([^\]]+)\]\(([^\)]+)\)/, '\1 \2')

    # generate html lists from mtlite 1-liner lists
    msg.gsub!(/\[[\*#][^\]]+\]/) do |list|

      if not list[/\n/] then

        symbol = list[1]
        symbol.prepend '\\' if symbol == '*'

        list.strip[1..-2].split(/#{symbol}/)[1..-1]\
          .map{|x| "\n* %s" % x.strip}.join + "\n"
      else
        list
      end

    end

    @msg = msg.gsub('<br/>',"\n").gsub(/<\/?.[^>]*>/,'')
  end

  private
  
  def smartlink(s)
    
    s.gsub(/\B\?([^\n]+) +(https?:\/\/.*\?)(?=\B)/) do
      "[%s](%s)" % [$1, ($2).chop]
    end

  end  
  
end