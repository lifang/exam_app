class Tag < ActiveRecord::Base
  has_many :question_tag_relations,:foreign_key => "tag_id"
end
