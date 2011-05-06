class Tag < ActiveRecord::Base
  has_many :question_tag_relations
  has_many:questions
end
