class Question < ActiveRecord::Base
  has_many:question_tags 
  belongs_to:question_category
  has_many:question_tag_relations
  has_many:block_question_relations
  has_many:question_points
end



