require 'spec_helper'

describe SessionsController do
  render_views
  describe "POST'create'"do
    before(:each)do
      session[:signin_code]="127834"
      @user=Factory(:user)
    end
    it "should post 'create'"do
      @user1=User.new(:name=>"qianjun",:email=>"er6788@126.com",:mobilephone=>"11111111111",:password=>"123456")
      @user1.encrypt_password
      @user1.save!
      post :create,:proof_code=>"127834",:session=>{:email=>@user1.email,:password=>"123456"}
      response.should  redirect_to("/papers")
    end
  end
end
