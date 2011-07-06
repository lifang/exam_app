require 'spec_helper'

describe User::ExaminationsController do
  before(:each) do
    @user = Factory(:user)
    @examination = Factory(:examination)
    @exam_user = ExamUser.create(:user_id => @user.id, :paper_id => 1, 
      :examination_id => @examination.id, :answer_sheet_url => "/result/1.xml")
  end

  it "should get one record" do
    get :index, :user_id => @user.id
    assigns[:examinations].size.should == 1
  end

  it "should can answer paper" do
    get :show, :id => @examination.id, :user_id => @user.id
    assigns[:examination].should == @examination
    assigns[:exam_user].should == @exam_user
    assigns[:exam_user].started_at.should_not be_nil
  end

  it "should save result" do
    @all_quesiton_ids = "152,153"
    post :save_result, :id => @examination.id, :user_id => @user.id, :all_quesiton_ids =>@all_quesiton_ids,
      :answer_152 => "what", :answer_153 => "Excuse me"
    assigns[:exam_user].should == @exam_user
    assigns[:exam_user].is_submited.should be true
  end

  it "should five min save" do
    @arr = "152,when,153,test test"
    post :five_min_save, :id => @examination.id, :user_id => @user.id, :arr => @arr
    assigns[:exam_user].should == @exam_user
  end

end