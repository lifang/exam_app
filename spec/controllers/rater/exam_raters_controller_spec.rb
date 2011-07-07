require 'spec_helper'
describe Rater::ExamRatersController do
  render_views
  describe "test all definde in rater/exam_raters " do
    before(:each) do
      @rater=Factory(:exam_rater)
      @examination=Factory(:examination)
      @exam_user=Factory(:exam_user,:examination_id=>@examination.id)
      cookies[:rater_id]=1
    end
    it " should have the right render" do
      #      @rater = ExamRater.all
      #      @examination = Examination.all
      #      @rater.size.should == 2
      #      @rater=ExamRater.first
      #      @examination = Examination.first
      get :rater_session,:id=> @rater,:examination=>@examination
      response.should render_template("session")
    end
    it "should  have the right redirect" do
      post :rater_login, :id=> @rater, :examination_id=>@examination, :author_code => "654916"
      response.should redirect_to reader_papers_rater_exam_rater_url(@examination)
    end
    it "should render session " do
      post :rater_login, :id=> @rater, :examination_id=>@examination, :author_code => "654976"
      response.should render_template("session")
    end

    it "should get reader_papers " do
      @user=Factory(:user)
      @examination = Factory.create(:examination, :creater_id => @user.id)
      get :reader_papers,:id=>@examination.id
      response.should be_success
    end
    it "should get reader_paper " do
      cookies[:rater_id]=1
      get :check_paper,:examination_id=>@exam_user.examination_id
      response.should redirect_to answer_paper_rater_exam_rater_url(@exam_user.id)
    end
    it "should get the request " do
      get :check_paper,:examination_id=>1
      response.should redirect_to request.referer
    end
    it " should get show" do
      get :show,:id=>@rater
      response.should be_success
    end
    it "should get answer_paper" do
      @exam_user=Factory(:exam_user)
      get :answer_paper,:id=>@exam_user
      response.should be_success
    end
    it "should get over_answer" do
      @exam_relation=Factory(:rater_user_relation)
      @exam_user=Factory(:exam_user,:id=>@exam_relation.exam_user_id)
      @exam_relation=Factory(:rater_user_relation,:exam_user_id=>@exam_user.id)
      get :over_answer,:id=>@exam_relation.exam_user_id
      response.should redirect_to reader_papers_rater_exam_rater_url(@exam_user.examination_id)
    end
  end
end
