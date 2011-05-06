class Question < ActiveRecord::Base
  has_many:question_tag_realtions
  has_many:tags
end
