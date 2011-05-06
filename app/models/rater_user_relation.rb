class RaterUserRelation < ActiveRecord::Base
  belongs_to :exam_rater
  belongs_to :exam_user
  belongs_to :examination
end
