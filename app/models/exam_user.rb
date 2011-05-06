class ExamUser < ActiveRecord::Base




  belongs_to :user
  has_many :rater_user_relations,:dependent=>:destroy
  belongs_to :examination
  has_many :exam_raters,:through=>:rater_user_relations,:foreign_key=>"exam_rater_id"
  belongs_to:paper

end
