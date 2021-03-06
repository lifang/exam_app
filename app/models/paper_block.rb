# encoding: utf-8
class PaperBlock < ActiveRecord::Base
  require 'rexml/document'
  include REXML

  belongs_to :paper

  def create_block_xml(url)
    file=File.open(url)
    doc=Document.new(file)
    file.close
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y-%m-%d %H:%M")
    blocks = doc.root.elements["blocks"]
    block = blocks.add_element("block")
    block.add_attribute("id","#{self.id}")
    block.add_attribute("total_score","0")
    block.add_attribute("total_num","0")
    block.add_attribute("time", "#{self.time}")
    block.add_attribute("start_time", "#{self.start_time}")
    base_info=block.add_element("base_info")
    title = base_info.add_element("title")
    title.add_text("#{self.title}")
    description = base_info.add_element("description")
    description.add_text("#{self.description}")
    problems = block.add_element("problems")
    self.write_xml(url, doc)
  end

  def update_block_xml(xpath)
    file=File.open("#{Rails.root}/public"+self.paper.paper_url)
    doc = Document.new(file)
    file.close
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y-%m-%d %H:%M")
    block=doc.elements[xpath]
    block.add_attribute("time", "#{self.time}")
    block.add_attribute("start_time", "#{self.start_time}")
    block.elements["base_info"].elements["title"].text=self.title
    block.elements["base_info"].elements["description"].text=self.description
    self.write_xml("#{Rails.root}/public"+self.paper.paper_url,doc)
  end

  def delete_block_xml
    file=File.open("#{Rails.root}/public"+self.paper.paper_url)
    doc = Document.new(file)
    file.close
    block = doc.root.elements["blocks/block[@id='#{self.id}']"]
    puts doc.root
    doc.root.attributes["total_score"] = (doc.root.attributes["total_score"].to_f - block.attributes["total_score"].to_f).round(2)     #更新试卷总分
    #更新试卷模块、试卷题目数
    doc.root.attributes["total_num"] = doc.root.attributes["total_num"].to_i - block.attributes["total_num"].to_i          #更新试卷总题数
    doc.delete_element("paper/blocks/block[@id='#{self.id}']")

    self.write_xml("#{Rails.root}/public"+self.paper.paper_url, doc)
  end

  def write_xml(url, doc)
    file = File.open(url, "w+")
    file.write(doc)
    file.close
  end
  
end


