class Paper < ActiveRecord::Base
  has_many :paper_blocks ,:dependent=>:destroy
  has_many :examination_paper_relations,:foreign_key=>"paper_id",:dependent=>:destroy
  has_many :examinations, :through=>:examination_paper_realations,:foreign_key=>"examination_id"
  belongs_to :user,:foreign_key=>"creater_id"
  belongs_to :category
  default_scope:order=>"id desc"

  #创建试卷基本信息
  def Paper.create_base_info(paper)

  end

  #创建试卷的文件
  def self.update_paper_url(str)

  end

  #发布试卷
  def self.published!(paper)

  end

end



