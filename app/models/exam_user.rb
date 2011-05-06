class ExamUser < ActiveRecord::Base
 
 belongs_to :user
  has_many :rater_user_relations
end
