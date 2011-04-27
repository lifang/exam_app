class ExamRater < ActiveRecord::Base
  belongs_to :exam_plan
  has_many :rater_record_relations
  has_many :exam_records,:through=>:rater_record_relations,:foreign_key=>:exam_record_id

  attr_accessible :name,:password,:mobilephone,:email,:password_confirmation

  email_regex=/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/i
	name_regex=/[a-zA-Z]{1,20}|[\u4e00-\u9fa5]{1,10}/
	#mobilephone_regex=/^[1-9]\d*$/

  validates :name,:presence=>true,:format=>{:with=>name_regex},:length=>{:maximum=>30}
  validates :email,:presence=>true,:uniqueness=>true,:format=>{:with=>email_regex},:length=>{:maximum=>50}
  validates:password,:presence=>true,:confirmation=>true,:length=>{:within=>6..20}
  
end
