class Paper < ActiveRecord::Base
  has_many:paper_blocks
  has_many:examinations
  belongs_to:user
end




