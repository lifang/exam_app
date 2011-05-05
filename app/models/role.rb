class Role < ActiveRecord::Base
  has_many :user_role_relations
  has_many :users,:through=>:user_role_relations,:foreign_key=>"user_id"
end
