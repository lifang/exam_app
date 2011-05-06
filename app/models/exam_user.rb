class ExamUser < ActiveRecord::Base
 has_many:exam_raters
 belongs_to :user
  has_many :rater_user_relations
end
