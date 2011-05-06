class ExamUser < ActiveRecord::Base
  belongs_to :user
  has_many :rater_user_relations,:dependent=>:destroy
  has_many :examinations,:through=>:rater_user_relations,:foreign_key=>"examination_id"
  has_many :exam_raters,:through=>:rater_user_relations,:foreign_key=>"exam_rater_id"
end
