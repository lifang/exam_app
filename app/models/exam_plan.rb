class ExamPlan < ActiveRecord::Base
  belongs_to:examnation
  has_many:exam_users
  has_many:exam_rater
end
