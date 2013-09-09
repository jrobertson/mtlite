#!/usr/bin/env ruby

# file: mtlite.rb

require 'markdown'

class MTLite
  def initialize(raw_msg)
    @raw_msg = raw_msg
  end

  def to_html()
    raw_msg = @raw_msg
    raw_msg.sub!(/\[\[.*\]/){|x| x[0..-2].gsub(/[^\n](\[[x\s]?\])/,'<br/>\1') }
    raw_msg = raw_msg.gsub(/\[\s*\]/,'&#9744;').gsub(/\[x\]/,'&#9745;')
    raw_msg = raw_msg.gsub('1/4','&#188;').gsub('1/2','&#189;').gsub('3/4','&#190;')

    raw_msg.gsub!(/\s-[^-]+-?[^-]+-[\s\]]/) do |x|
      x.sub(/-([&\w]+.*\w+)-/,'<del>\1</del>')
    end
    
    raw_msg.gsub!(/(?:^\[|\s\[)[^\]]+\]\((https?:\/\/[^\s]+)/) do |x|
      s2 = x[/https?:\/\/([^\/]+)/,1].split(/\./)
      r = s2.length >= 3 ? s2[1..-1] :  s2
      "%s [%s]" % [x, r.join('.')]
    end
    
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

    msg = Markdown.new(raw_msg).to_html.gsub(/<\/?p[^>]*>/,'')
    msg.gsub!(/(?:^(https?:[^\s]+)|\s(https?:[^\s]+))/,' <a href="\2">\2</a>')    
    msg.gsub!(/<a /,'<a target="_blank" ')
    len = msg.gsub(/<\/?.[^>]*>/,'').length

    msg
  end
end
