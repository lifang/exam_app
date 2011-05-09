class Examination < ActiveRecord::Base
  has_many :examintion_paper_relations,:dependent => :destroy
  has_many :papers,:through=>:examination_paper_relations,:foreign_key=>"paper_id"
  has_many :score_levels,:dependent=>:destroy
  belongs_to :user,:foreign_key=>"creater_id"
  has_many :exam_users
  has_many :exam_raters


 #创建考试
 def Examination.create_examination(attr_hash)

   #return examination
 end

 #创建考试试卷
 def self.set_papers(*paper)

   #return true or false
 end


 #选择试卷
 def self.choose_paper(papers_array)

   #return true or false
 end

 #创建考生
 def self.create_exam_users(*user)
   
   #return true or false
 end

 #创建批卷老师
 def self.create_exam_rater(*rater)

   #return true or false
 end

end
