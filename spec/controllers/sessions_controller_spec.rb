require 'spec_helper'

describe SessionsController do
  render_views
  describe "POST'create'"do
    it "should be right page" do
      @attr={:email=>"",:password=>""}
      post:create,:session=>@attr
      response.should be_success
    end
    it"should be the right page"do
      @attr={:email=>"1111@126.com",:password=>"11"}
      post:create,:session=>@attr
      response.should be_success
    end
    it"should be the right page"do
       @attr={:email=>"",:password=>""}
	     post:create,:session=>@attr
       response.should render_template('new')
    end
    end
end
