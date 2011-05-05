class Tag < ActiveRecord::Base
  has_many :problem_tag_relations
end
