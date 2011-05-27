
text   "The　 Ruby　Way"
book1=XPath.first(doc,"//book") #　Info　for　first　book　found　
p book1

#　Print　out　 all　titles　
XPath.each(doc,"//title") {|e| puts e.text}

# 　Get　an　array　of　all　of　the　"author"　elements　in　the　document.　
names = XPath.match(doc,"//author").map {|x| x.text}
p names