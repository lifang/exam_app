class RaterRecordRelation < ActiveRecord::Base
  belongs_to :exam_record
  belongs_to :exam_rater
end
