class Paper < ActiveRecord::Base
  has_many:paper_blocks
  has_many:examinations
end




