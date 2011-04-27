class Paper < ActiveRecord::Base
  has_many:paper_blocks
  has_many:examinations
  belongs_to :user

  attr_accessible :title,:type,:creater_id,:description,:total_score,:total_question_num
  
	validates:title,  :presence=>true
	validates:type,  :presence=>true

  
end




