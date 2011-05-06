class Examination < ActiveRecord::Base
  has_many :examintion_paper_relations,:dependent => :destroy
  has_many :papers,:through=>:examination_paper_relations,:foreign_key=>"paper_id"
  has_many :score_levels,:dependent=>:destroy
  belongs_to :user,:foreign_key=>"creater_id"
  has_many :rater_user_relations,:dependent=>:destroy
  has_many :exam_users
  has_many :exam_raters


end
