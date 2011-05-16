class Paper < ActiveRecord::Base

  require 'rexml/document'
   include REXML

  has_many :paper_blocks ,:dependent=>:destroy
  has_many :examination_paper_relations,:foreign_key=>"paper_id",:dependent=>:destroy
  has_many :examinations, :through=>:examination_paper_realations,:foreign_key=>"examination_id"
  belongs_to :user,:foreign_key=>"creater_id"
  belongs_to :category
  default_scope:order=>"id desc"

  #更新试卷基本信息
  def update_base_info(url)
    doc=Document.new(File.open(url))
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y年%m月%d日%H时%M分")
    doc.root.elements["base_info"].elements["title"].text=self.title
    doc.root.elements["base_info"].elements["description"].text=self.description
    file=File.open(url,"w+")
    file.write(doc)
    file.close
  end


  def create_paper_url(str)
    dir = "#{Rails.root}/public/papers/"      #定义：目录
    unless File.directory?(dir)               #判断dir目录是否存在，不存在则创建 下3行
      Dir.mkdir(dir)
    end
    file_name = "#{self.id}.xml"                          #定义：文件名
    url = dir+file_name                                   #定义：url = 目录+文件名
    f=File.new(url,"w")                                   #写文件操作  下3行
    f.write("#{str.force_encoding('UTF-8')}")
    f.close
    self.paper_url = url                      #字段paper_url = url
    self.save
  end

  #创建试卷的文件
  def self.update_paper_url(str)
    
  end

  #发布试卷
  def self.published!(paper)

  end
  
  def xml_content(creater_name)
    content ="<?xml version='1.0' encoding='UTF-8'?>"
    content+="<paper id='#{self.id}' total_num='0' total_score='0'>"
    content+="<base_info>"
    content+="<title>#{self.title}</title>"
    content+="<creater>#{creater_name}</creater>"
    content+="<created_at>#{self.created_at.strftime("%Y年%m月%d日%H时%M分").force_encoding('ASCII-8BIT')}</created_at>"
    content+="<updated_at>#{self.updated_at.strftime("%Y年%m月%d日%H时%M分").force_encoding('ASCII-8BIT')}</updated_at>"
    content+="<description>#{self.description.force_encoding('ASCII-8BIT')}</description>"
    content+="</base_info>"
    content+="<blocks>"
    content+="</blocks>"
    content+="</paper>"
  end
  
end



