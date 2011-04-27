

describe PapersController do
render_views
#  describe "GET 'show'" do
#    it "should be successful" do
#      get 'show'
#      response.should be_success
#    end
#  end

  describe "GET 'edit'" do
    before(:each) do
   @attr={:title=>"example",:types=>"java",:user_id=>1,:description=>"ssdfgggg",:total_question_num=>12,:total_score=>"100"}
 end
    it "should have the right show" do
      get 'index',:paper=>@attr
      response.shold have_selector("td",:content=>"example")
    end
  end

end
