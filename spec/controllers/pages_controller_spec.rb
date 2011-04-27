require 'spec_helper'

describe PagesController do
render_views


  describe "GET 'index'" do
    before(:each) do
   @attr={:title=>"example",:types=>"java",:creater_id=>1,:description=>"ssdfgggg",:total_question_num=>12,:total_score=>"100"}
 end
    it "should have the right show" do
      get 'index',:paper=>@attr
      response.shold have_selector("td",:content=>"example")
    end
  end
end
