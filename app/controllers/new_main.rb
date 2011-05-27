require 'rexml/document'
require 'rexml/streamlistener'
include REXML
class MyListener
include REXML::StreamListener
def tag_start(*args)
puts "tag_start:　#{args.map {|x| x.inspect}.join(',　')}"
end

def text(data)
return data if data= ~/^\w*$/  #　whitespace　only　
abbrev="..."
puts "text:#{abbrev.inspect}"
end
end

list= MyListener.new
source=File.new("f:/book.xml")
Document.parse_stream(source,list)

puts "______________________"
book1=XPath.first(doc,"//book") #　Info　for　first　book　found　
puts book1

#　Print　out　 all　titles　
XPath.each(doc,"//title") {|e| puts e.text}

# 　Get　an　array　of　all　of　the　"author"　elements　in　the　document.　
names = XPath.match(doc,"//author").map {|x| x.text}
puts names