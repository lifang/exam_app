class Paper < ActiveRecord::Base
  has_many:paper_blocks ,:dependent=>:destroy
  has_many:examinations

  belongs_to:user,:foreign_key=>"creater_id"

  default_scope:order=>"id desc"
end



