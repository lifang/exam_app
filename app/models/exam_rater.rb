class ExamRater < ActiveRecord::Base
  belongs_to :exam_plan
  has_many :rater_record_relations
  has_many :exam_records,:through=>:rater_record_relations,:foreign_key=>:exam_record_id
end
