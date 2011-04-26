class ExamRecord < ActiveRecord::Base
  belongs_to :exam_user
  belongs_to :examination
  has_many :rater_record_relations
  has_many :exam_raters,:through=>:rater_record_relations,:foreign_key=>:exam_rater_id
end
