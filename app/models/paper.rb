class Paper < ActiveRecord::Base

  has_many :paper_blocks ,:dependent=>:destroy
  has_many :examination_paper_relations,:foreign_key=>"paper_id"
  has_many :examinations, :through=>:examination_paper_realations,:foreign_key=>"examination_id"
  belongs_to :user,:foreign_key=>"creater_id"
  belongs_to :category
  default_scope:order=>"id desc"

end



