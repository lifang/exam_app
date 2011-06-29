require 'spec_helper'

describe Examnation do
  before(:each) do
    @user = Factory(:user)
    @examination = Factory.create(:examination, :creater_id => @user.id)
  end

  it "should create a new examination" do   
    Examination.should have(1).record
    @examination.title.should == "examination test"
  end

  it "should have record" do
    @title = "examination test"
    @examinations = Examination.search_method(@user.id, nil, nil, @title, 1, 10)
    @examinations.size.should == 1

    @title = "examination test1"
    @examinations = Examination.search_method(@user.id, nil, nil, @title, 1, 10)
    @examinations.blank?.should be true
  end

  it "should create score_level" do
    @score_array = ["100-90", "youxiu", "89-80", "lianghao", "79-70", "yiban", "69-60", "hege", "60yixia", "bujige"]
    @examination.update_score_level(@score_array)
    ScoreLevel.should have(5).records
  end

  it "should join a examination" do
    @paper = Factory(:paper)
    @user = Factory(:user)
    @exam_user = ExamUser.create(:paper, :examination, :user)
    Examination.return_examinations(@user.id).blank?.should be_false
  end
  
  
end
