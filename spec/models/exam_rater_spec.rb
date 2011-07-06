require 'spec_helper'

describe ExamRater do
  before(:each) do
    @examination = Factory(:examination)
  end
  it "should create three exam_rater" do
    
    @info = ["test1", "test1@126.com", "12345678901", "test2", "test2@126.com",
      "12345678902", "test3", "test3@126.com", "12345678903"]
    lambda{
      @exam_raters = ExamRater.create_raters(@info,@examination)
    }.should change(ExamRater, :count).by(3)
    
  end

  it "should alreay in exam_rater" do
    @rater_attr = {:name => "rater1", :mobilephone => "12345678904", 
      :email => "rater1@126.com", :examination_id => @examination.id}
    @rater1 = ExamRater.create(@rater_attr)
    @rater2 = ExamRater.create(@rater_attr.merge(:name => "rater2", :email => "rater2@126.com"))
    @rater3 = ExamRater.create(@rater_attr.merge(:name => "rater3", :email => "rater3@126.com"))
    @info = ["rater1", "rater1@126.com", "12345678901", "rater2", "rater2@126.com",
      "12345678902", "rater3", "rater3@126.com", "12345678903"]
    @exam_raters = ExamRater.check_rater(@info, @examination.id)
    @exam_raters.should_not be_empty
    
  end
end
