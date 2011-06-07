class Role < ActiveRecord::Base
  has_many :user_role_relations,:dependent=>:destroy
  has_many :users,:through=>:user_role_relations,:foreign_key=>"user_id"

  TYPES = {:STUDENT => 2, :TEACHER => 1}  #1 考试组织人  2 考生
end
