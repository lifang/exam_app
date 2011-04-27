class User < ActiveRecord::Base
  has_many:papers
  default_scope :order=>'users.created_at desc'

  email_regex=/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/i
	name_regex=/[a-zA-Z]{1,20}|[\u4e00-\u9fa5]{1,10}/
	#telephone_regex=/^[1-9]\d*$/
  

end
