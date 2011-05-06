class Tag < ActiveRecord::Base
  has_many :problem_tag_relations
  has_many :question_tag_relations
end
