class PaperBlock < ActiveRecord::Base
   require 'rexml/document'
   include REXML

   belongs_to :paper

  def update_block_xml(url)
  #  dir = "#{Rails.root}/public/papers/"                  #定义：目录
  #  file_name = "#{paper_id}.xml"                          #定义：文件名
  #  url = dir+file_name                                   #定义：url = 目录+文件名
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

  def base_block
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
  end

end


