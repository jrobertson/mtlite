#!/usr/bin/env ruby

# file: mtlite.rb

require 'rdiscount'

class MTLite
  
  def initialize(raw_msg)

    # make the smartlinks into Markdown links
    raw_msg.gsub!(/\B\?([^\n]+) +(https?:\/\/[^\b]+)\?\B/,'[\1](\2)')
    
    @raw_msg = raw_msg
    
  end

  def to_html()

    raw_msg = @raw_msg.clone    
    # if it looks like an MtLite list make it an MtLite list
    # e.g. "a todo list:\n* line 1\n* line 2" => 
    #                                       a todo list: [* line 1 * line 2]
    raw_msg.sub!(/^(?:[\*#][^\n]+\n?)+/,'[\0]')
    raw_msg.gsub!(/\n/,' ')


    # add br tags to checklist items
    # todo list: [[x] line 1 [] line 2] => 
    #                         todo list: <br/>[x] line 1 <br/>[] line 2
    raw_msg.sub!(/\[\[.*\]/){|x| x[0..-2].gsub(/[^\n](\[[x\s]?\])/,'<br/>\1') }

    # convert square brackets to unicode check boxes
    # replaces a [] with a unicode checkbox, 
    #                         and [x] with a unicode checked checkbox
    raw_msg = raw_msg.gsub(/\[\s*\]/,'&#9744;').gsub(/\[x\]/,'&#9745;')

    # convert fractions using their associated unicode character
    # i.e. 1/4, 1/2, 3/4 
    raw_msg = raw_msg.gsub('1/4','&#188;').gsub('1/2','&#189;').gsub('3/4','&#190;')

    # add strikethru to completed items
    # e.g. -milk cow- becomes <del>milk cow</del>
    raw_msg.gsub!(/\s-[^-]+-?[^-]+-[\s\]]/) do |x|
      x.sub(/-([&\w]+.*\w+)-/,'<del>\1</del>')
    end
      
    # append a domain label after the URL
    raw_msg.gsub!(/(?:^\[|\s\[)[^\]]+\]\((https?:\/\/[^\s]+)/) do |x|
      s2 = x[/https?:\/\/([^\/]+)/,1].split(/\./)
      r = s2.length >= 3 ? s2[1..-1] :  s2
      "%s [%s]" % [x, r.join('.')]
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

    msg = RDiscount.new(raw_msg).to_html.gsub(/<\/?p[^>]*>/,'')
    # generate anchor tags for URLs which don't have anchor tags
    msg.gsub!(/(?:^(https?:[^\s]+)|\s(https?:[^\s]+))/,' <a href="\2">\2</a>')    
    # add the target attribute to make all hyperlinks open in a new browser tab
    msg.gsub!(/<a /,'<a target="_blank" ')
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
  
end
