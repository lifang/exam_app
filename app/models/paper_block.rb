class PaperBlock < ActiveRecord::Base
   require 'rexml/document'
   include REXML

   belongs_to :paper

  def create_block_xml(url)
    doc=Document.new( File.open(url) )
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y年%m月%d日%H时%M分")
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
    self.write_xml(url, doc)
  end

  def update_block_xml(xpath)
    doc = Document.new(File.open("#{Rails.root}/public"+self.paper.paper_url))
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y年%m月%d日%H时%M分")
    block=doc.elements[xpath]
    block.elements["base_info"].elements["title"].text=self.title
    block.elements["base_info"].elements["description"].text=self.description
    self.write_xml("#{Rails.root}/public"+self.paper.paper_url,"w+", doc)
  end

  def delete_block_xml
    doc = Document.new(File.open("#{Rails.root}/public"+self.paper.paper_url))
    doc.delete_element "paper/blocks/block[@id='#{self.id}']"
    self.write_xml("#{Rails.root}/public"+self.paper.paper_url, doc)
  end

  def write_xml(url, doc)
    file = File.open(url, "w+")
    file.write(doc)
    file.close
  end
  
end


