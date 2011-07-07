require 'spec_helper'
describe ExamUsersController do
  render_views
  describe "test all  in exam_users" do
    before(:each) do
      @user=Factory(:user)
      @examination=Factory(:examination)
    end
    it "should test 'create_exam_user' get 'be_joined'" do
      @exam_user=Factory(:exam_user,:examination_id=>@examination.id,:user_id=>@user.id)
      get :create_exam_user,:examination_id=>@examination.id,:exam_user_infoemail=>@user.email,:exam_user_infoname=>@user.name
      assigns[:exam_users].size.should == 1
      flash[:warn].should =~ /be_joined/i
    end
    it "should test 'create_exam_user' get 'be_used'" do
      get :create_exam_user,:examination_id=>@examination.id,:exam_user_infoemail=>@user.email,:exam_user_infoname=>"qianjun"
      assigns[:exam_users].size.should == 0
      flash[:warn].should =~ /be_used/i
    end
    it "should test 'create_exam_user' get 'new_exam_user' without new_user" do
      get :create_exam_user,:examination_id=>@examination.id,:exam_user_infoemail=>@user.email,:exam_user_infoname=>@user.name,
        :exam_user_infomobile=>"11111111111"
      ExamUser.should have(1).record
    end
    it "should test 'create_exam_user' get new_exam_user and new_user" do
      get :create_exam_user,:examination_id=>@examination.id,:exam_user_infoemail=>"er6788@163.com",:exam_user_infoname=>"qianjun2",
        :exam_user_infomobile=>"11111111111"
      User.should have(2).record
      ExamUser.should have(1).record
    end
    it "test login should get new_exam_user" do
      post :login,:id=> @examination.id,:user_info=>"qianjun er6788@126.com 15295652460"
      ExamUser.should have(1).record
    end
    it "should delete exam_user" do
      @exam_user = ExamUser.create(:examination_id => @examination.id, :paper_id => 1, :user_id => 1)
      delete :destroy, :id => @exam_user.id, :page => 1
      assigns[:exam_users].size.should == 0
      ExamUser.should have(0).record
    end
  end
  describe "test all  in update_exam_user" do
    before(:each) do
      @user=Factory(:user)
      @exam_user=Factory(:exam_user,:user_id=>@user.id)
    end
    it "should update_exam_user but find_by email" do
      post :update_exam_user,:id=> @exam_user.id,:email=>"er6788@126.com",:name=>"qianjun",:mobilephone=>"15295652460"
      assigns[:user].name.should == "qianjun"
      assigns[:user].email.should =="er6788@126.com"
    end
    it "should update_exam_user with a same email and return true" do
      post :update_exam_user,:id=> @exam_user.id,:email=>@user.email,:name=>"qianjun",:mobilephone=>"15295652460"
      assigns[:user].name.should == "qianjun"
    end
    it "should update_exam_user with a same email but return false" do
      @user1=User.create(:name=>"qianjun",:email=>"er6788@126.com",:mobilephone=>"11111111111")
      post :update_exam_user,:id=> @exam_user.id,:email=>"er6788@126.com"
      flash[:error].should =~ /be_used/i
      assigns[:user].name.should == "jeffrey"
    end
  end
end
