class Paper < ActiveRecord::Base
  has_many:paper_blocks
  has_many:examinations

  belongs_to:user,:foreign_key=>"creater_id"

end



