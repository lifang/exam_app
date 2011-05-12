class Examination < ActiveRecord::Base
  has_many :examination_paper_relations,:dependent => :destroy
  has_many :papers,:through=>:examination_paper_relations,:foreign_key=>"paper_id"
  has_many :score_levels,:dependent=>:destroy
  belongs_to :user,:foreign_key=>"creater_id"
  has_many :exam_users,:dependent => :destroy
  has_many :exam_raters,:dependent => :destroy


 #创建考试
 def Examination.create_examination(attr_hash)
   return Examination.create(attr_hash)
   #return examination
 end

 #创建考试试卷
 def self.set_papers(*paper)
   
   #return true or false
 end


 #选择试卷
 def choose_paper(papers_array)
   self.papers = papers_array

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

 def publish!
   self.toggle!(:is_published)
 end

end
