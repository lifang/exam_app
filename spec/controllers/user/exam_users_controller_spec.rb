require 'spec_helper'

describe User::ExamUsersController do
  describe "test all define in user/exam_users" do
    before(:each) do
      @user=Factory(:user)
      @examination=Factory(:examination)
      @exam=Factory(:exam_user,:examination_id=>@examination.id,:user_id=>@user.id)
      cookies[:user_id]=1
    end
    it "should get show " do
      get :show,:id=>@exam.examination_id, :user_id=>@exam.user_id
      response.should be_success
    end
  end
end
