Introducing the Mtlite gem

The Mtlite gem was inspired by the Martile gem to facilitate transforming a kind of a loose Martile markdown.

It features the following:

* Making an unordered list into an Mtlite 1-liner list e.g. 
    "a todo list:\n* line 1\n* line 2" =&gt;   a todo list: [* line 1 * line 2]
* Adding br tags to checklist items e.g. 
    todo list: [[x] line 1 [] line 2] =&gt;  todo list: &lt;br/&gt;[x] line 1 &lt;br/&gt;[] line 2
* Convert square brackets to unicode check boxes; Replaces a [] with a unicode checkbox, and [x] with a unicode checked checkbox
* Convert fractions using their associated unicode character i.e. 1/4, 1/2, 3/4
* Adding strikethru to completed items  e.g. -milk cow- becomes &lt;del&gt;milk cow&lt;/del&gt;
* Appending a domain label after the URL
* Generate html lists from Mtlite 1-liner lists.

## Examples

    require 'mtlite'

    MTLite.new("a todo list:\n* line 1\n* line 2").to_html
    #=&gt; "a todo list: &lt;ul&gt;&lt;li&gt;line 1&lt;/li&gt;&lt;li&gt;line 2&lt;/li&gt;&lt;/ul&gt;\n" 

    MTLite.new("todo list: [[x] line 1 [] line 2]").to_s
    #=&gt; "todo list: \nâ˜‘ line 1\nâ˜ line 2\n" 

    MTLite.new("todo list: [[x] line 1 [] line 2]").to_html
    #=&gt; "todo list: &lt;br/&gt;â˜‘ line 1&lt;br/&gt;â˜ line 2\n" 

    MTLite.new("2 apples and 1/2 teaspoon of cinamon powder").to_s
    #=&gt; "2 apples and Â½ teaspoon of cinamon powder\n" 

    MTLite.new(" -milk cow- ").to_html
    #=&gt; " &lt;del&gt;milk cow&lt;/del&gt;\n" 

    MTLite.new(" find out more from http://news.bbc.co.uk").to_html
    #=&gt; " find out more from &lt;a target=\"_blank\" href=\"http://news.bbc.co.uk\"&gt;http://news.bbc.co.uk&lt;/a&gt;\n"
 
## Resources

* [jrobertson/mtlite](https://github.com/jrobertson/mtlite)

mtlite gem markdown martile html
