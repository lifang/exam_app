
require 'spec_helper'
describe PapersController do
render_views

  describe "GET 'edit'" do
   before(:each) do
   @attr={:title=>"example",:types=>"java",:creater_id=>1,:description=>"ssdfgggg",:total_question_num=>12,:total_score=>"100"}
   Paper.create!(@attr)
 end
    it "should have the right show" do
      get 'index',:paper=>@attr
      response.should have_selector("td",:content=>"java")
    end
  end
end
