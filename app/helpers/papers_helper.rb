module PapersHelper
  require 'rexml/document'
  include REXML

  def xml_delete_problem(url,problem_xpath)
    doc=Document.new( File.open(url) )
    block=doc.elements[problem_xpath].parent.parent
    doc.root.attributes["total_num"] = doc.root.attributes["total_num"].to_i - 1                   #更新试卷总题数 +1
    block.attributes["total_num"] = block.attributes["total_num"].to_i - 1                         #更新试卷总题数 -1
    doc.root.attributes["total_score"] = doc.root.attributes["total_score"].to_i - doc.elements[problem_xpath].attributes["score"].to_i                                                                                                #更新试卷总分
    block.attributes["total_score"] = block.attributes["total_score"].to_i - doc.elements[problem_xpath].attributes["score"].to_i                                                                                                 #更新模块总分
    doc.delete_element(problem_xpath)
    file=File.open(url, "w+")
    file.write(doc)
    file.close
  end

end
