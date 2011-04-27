class User < ActiveRecord::Base

  has_many :papers,:foreign_key=>:creater_id

  default_scope :order=>'users.created_at desc'

  email_regex=/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/i
	name_regex=/[a-zA-Z]{1,20}|[\u4e00-\u9fa5]{1,10}/
	#telephone_regex=/^[1-9]\d*$/
	attr_accessible :name,:telephone,:email,:password,:salt,:encryted_password,:password_confirmation

	validates:name,  :presence=>true,:format=>{:with=>name_regex},:length=>{:maximum=>30}

	#validates:telephone,  :presence=>true,
	#                      :length=>{:within=>8..12},
	#					  :format=>{:with=>telephone_regex}

	validates:email,  :presence=>true,:uniqueness=>true,:format=>{:with=>email_regex},:length=>{:maximum=>50}

  validates:password, :presence=>true,:confirmation=>true,:length=>{:within=>6..20}
  
end
