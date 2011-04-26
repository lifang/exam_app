class ExamRecord < ActiveRecord::Base
  belongs_to :exam_user
  belongs_to :examination
  has_many :rater_record_relations
end
