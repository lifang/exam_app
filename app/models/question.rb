class Question < ActiveRecord::Base
  has_many:question_tags
  belongs_to:question_categories
  has_many:question_tag_relations, :foreign_key =>"question_id"
  has_many:block_question_relations, :foreign_key => "question_id"
end
