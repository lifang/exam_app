require 'rexml/document'
include REXML

input=File.new("f:/book.xml")
doc=Document.new(input)

root=doc.root
puts root.attributes["shelf"]  #　Recent　Acquisitions　

doc.elements.each("library/section"){|e| puts e.attributes["name"]}
#　Output:　
#　　Ruby　
#　　 Space　

doc.elements.each("*/section/book") {|e| puts e.attributes["isbn"]}
#　Output:　
#　　0672328844　
#　　0321445619 　
#　　0684835509　
#　　074325631X　
sec2=root.elements[2]
author=sec2.elements[1].elements["author"].text  #　Robert　Zubrin
puts author
#这里要注意的是xml中的属性和值被表示为一个hash，因此我们能够通过attributes[]来提取我们需要的值，
#元素的值还能通过类似于 path的字符串或者整数来取得.其中用整数取的话，是1-based而不是0-based.
#tag_start   "library",{"shelf"=>"Recent Acquisitions"}
#tag_start "section",{"name"=>"Ruby"}
#tag_start "book",{"isbn"=>"0672328844"}
#tag_start "title",{}
book1=XPath.first(doc,"//book") #　Info　for　first　book　found　
puts book1

#　Print　out　 all　titles　
XPath.each(doc,"//title") {|e| puts e.text}

# 　Get　an　array　of　all　of　the　"author"　elements　in　the　document.　
names = XPath.match(doc,"//author").map {|x| puts x.text}
puts names