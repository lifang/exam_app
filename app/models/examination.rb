class Examination < ActiveRecord::Base
  has_many :examintion_paper_relations,:dependent => :destroy
  has_many :score_levels
  has_many :exam_users
  belongs_to :paper,:dependent => :destroy,:through=>:examination_paper_relations,:foreign_key=>"user_id"
  belongs_to :user

end
