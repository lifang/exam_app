require 'spec_helper'

describe ExaminationsController do
  render_views
  describe "test all in examinations " do
    before(:each) do
      cookies[:user_id]=1
      @paper=Factory(:paper)
      @user=Factory(:user)
      @examination=Factory(:examination)
    end
    it "should test create but return false" do
      post  :create, :exam =>{:getvalue =>"" }
      assigns[:paperid].should == ""
      response.should redirect_to("/papers")
    end
    it "should test create but return true" do
      post :create, :exam =>{:getvalue =>@paper.id.to_s }
      Examination.should have(2).record
    end
    it "should test 'create_step_one' but return true" do
      post :create_step_one,:id=>@examination.id,:post_value=>@paper.id,:timelimit=>0,:description=>"this is a title",
        :title=>"answer",:timeout=>120
      assigns[:examination].exam_time.should == 120
      assigns[:examination].description.should == "this is a title"
      response.should redirect_to(examination_path(@examination))
    end
    it "should test 'export_user_unaffirm' " do
      @exam_user=Factory(:exam_user,:user_id=>@user.id,:examination_id=>@examination.id)
      get :export_user_unaffirm,:id=>@examination.id
      response.should be_success
    end
    it "should test 'search_papers' " do
      @examiantion_papers=ExaminationPaperRelation.create(:examination_id=>@examination.id,:paper_id=>@paper.id)
      get :search_papers,:id=>@examination.id,:page=>2
      response.should be_success
    end
  end

end
