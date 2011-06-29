require 'spec_helper'

describe ExamUser do
  before(:each) do
    @user = Factory(:user)
    @examination = Factory.create(:examination, :creater_id => @user.id)
    @paper = Factory.create(:paper, :is_used => 1)
    @examination_paper_relation = ExaminationPaperRelation.create(:examination_id => @examination.id, :paper_id => @paper.id)
  end
  
  it "should have one exam_user in examinations" do
    @exam_user = ExamUser.create(:examination_id => @examination.id, :user_id => @user.id, :paper_id => @paper.id)
    @exam_users = ExamUser.select_exam_users(@examination.id)
    @exam_users.size.should == 1
  end

  it "should have one exam_user in examinations result" do
    @exam_user = ExamUser.create(:examination_id => @examination.id, :user_id => @user.id, :paper_id => @paper.id)
    @exam_users = ExamUser.select_exam_users(@examination.id)
    @exam_users.size.should == 1
  end

  it "should return a score_level hash" do
    @score_array = ["100-90", "youxiu", "89-80", "lianghao", "79-70", "yiban", "69-60", "hege", "60-1", "bujige"]
    @examination.update_score_level(@score_array)
    @exam_user_array = []
    @exam_user1 = ExamUser.create(:examination_id => @examination.id, :user_id => @user.id, 
      :paper_id => @paper.id, :total_score => 95)
    @exam_user2 = ExamUser.create(:examination_id => @examination.id, :user_id => @user.id,
      :paper_id => @paper.id, :total_score => 75)
    @exam_user_array << @exam_user1 << @exam_user2
    ScoreLevel.should have(5).records
    @exam_user_array.size.should == 2
    @examination.score_levels = ScoreLevel.all
    @examination.score_levels.size.should == 5
    @result_hash = ExamUser.score_level_result(@examination, @exam_user_array)
    @result_hash.size.should == 7
    @result_hash["youxiu"].should == 1
    @result_hash["yiban"].should == 1
    @result_hash["hege"].should == 0
  end

  it "should the exam_user in this examination" do
    @exam_user = ExamUser.create!(:examination_id => @examination.id, :user_id => @user.id, :paper_id => @paper.id)
    @exam_user.user_id.should == @user.id
    @e = ExamUser.first(:conditions => "examination_id = #{@examination.id} and user_id = #{@user.id}")
    @e.user_id.should == @user.id
  end

  it "should the exam_user alreay in this examination" do
    @info = ["test1", "test1@126.com", "12345678901", "test2", "test2@126.com",
      "12345678902", "test3", "test3@126.com", "12345678903"]
    @str = ExamUser.judge(@info,@examination.id)
    @str.should be_empty
  end

  it "should create three exam_users" do
    @info = ["exam_user1", "exam_user1@126.com", "12345678901", "exam_user2", "exam_user2@126.com",
      "12345678902", "exam_user3", "exam_user3@126.com", "12345678903"]
    lambda{
      ExamUser.login(@info, @examination)
      }.should change(ExamUser, :count).by(3)
  end
  
end
