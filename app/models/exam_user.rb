class ExamUser < ActiveRecord::Base
  belongs_to :exam_plan
  has_one :exam_record
end
