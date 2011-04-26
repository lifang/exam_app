class ExamRater < ActiveRecord::Base
  belongs_to :exam_plan
  has_many :rater_record_relations
end
