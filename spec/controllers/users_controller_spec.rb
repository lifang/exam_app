require 'spec_helper'

describe UsersController do
  describe "test all defines in users_controllers" do
    before(:each) do
      @user=Factory(:user)
    end
    it "should create a new user return true" do
      post :create,:user=>{:name=>"qianjun",:email=>"er6788@126.com",:mobilephone=>"15295652460",
        :password=>"qianjun",:password_confirmation=>"qianjun"}
      response.should redirect_to(active_user_path(assigns(:user)))
    end
    it "should create a new user with an used email" do
      post :create,:user=>{:name=>"qianjun",:email=>"jeffrey6052@163.com",:mobilephone=>"15295652460",
        :password=>"qianjun",:password_confirmation=>"qianjun"}
      response.should redirect_to("/users/new")
    end
    it "should test user_active " do
      get :user_active,:id=>@user.id,:active_code=>@user.active_code
      assigns[:user].active_code.should eq ""
      assigns[:user].status.should eq 1
      response.should redirect_to("/users/active_success")
    end
    it "should update a user " do
      @user1=User.new(:name=>"qianjun",:email=>"er6788@126.com",:mobilephone=>"11111111111",:password=>"123456")
      @user1.encrypt_password
      @user1.save!
      put :update,:id=>@user1.id,:user=>{:old_password=>"123456",:password=>"qianjun"}
      assigns[:user].has_password?("qianjun").should be_true
      response.should redirect_to request.referer
    end
  end
end
