class PaperBlock < ActiveRecord::Base
   require 'rexml/document'
   include REXML

   belongs_to :paper

  def create_block_xml(url)
    doc=Document.new( File.open(url) )
    blocks = doc.root.elements["blocks"]
    block = blocks.add_element("block")
    block.add_attribute("id","#{self.id}")
    block.add_attribute("total_score","0")
    block.add_attribute("total_num","0")
    base_info=block.add_element("base_info")
    title = base_info.add_element("title")
    title.add_text("#{self.title}")
    description = base_info.add_element("description")
    description.add_text("#{self.description}")
    problems = block.add_element("problems")
    file = File.open(url, "w+")
    file.write(doc)
    file.close
  end

  def update_block_xml(xpath)
    doc=Document.new(File.open(self.paper.paper_url))
    block=doc.elements[xpath]
    block.elements["base_info"].elements["title"].text=self.title
    block.elements["base_info"].elements["description"].text=self.description
    file = File.open(self.paper.paper_url,"w+")
    file.write(doc)
    file.close
  end
  
end


