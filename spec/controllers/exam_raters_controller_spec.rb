require 'spec_helper'
describe ExamRatersController do
  render_views
  describe "test all  in exam_raters" do
    before(:each) do
      @examination=Factory.create(:examination)
      @rater=Factory.create(:exam_rater,:examination_id=>@examination.id)
    end
    it "in 'create_exam_rater' should return false" do
      get :create_exam_rater,:examination_id=>@rater.examination_id,:exam_rater_infoemail=>@rater.email
      assigns[:exam_raters].size.should==1
      flash.now[:error].should =~ /be_joined/i
    end
    it "in 'create_exam_rater' should return true" do
      get :create_exam_rater,:examination_id=>@examination.id,:exam_rater_infoemail=>"er6788@163.com",
        :exam_rater_infoname=>"qianjun",:exam_rater_infomobile=>"12222222222"
      assigns[:exam_raters].size.should==2
      ExamRater.should have(2).record
    end
    it "should delete exam_rater" do
      lambda do
        delete :destroy,:id=>@rater.id
      end.should change(ExamRater,:count).by(-1)
      assigns[:exam_raters].size.should==0
    end
    it " should  create new_rater by login_rater" do
      post :login_rater,:id=> @examination.id,:rater_info=>"qianjun er6788@qq.com 15295652460",:page=>1
      assigns[:exam_raters].size.should==2
      ExamRater.should have(2).record
    end
    it "should update_exam_rater" do
      post :update_exam_rater,:id=>@rater.id,:email=>@rater.email,:name=>"qianjun1",:mobilephone=>"15295652460"
      assigns[:exam_rater].mobilephone.should =="15295652460"
      assigns[:exam_rater].name.should =="qianjun1"
    end
    it "should update_exam_rater" do
      @exam_rater=ExamRater.create(:name=>"wangjun",:email=>"wangjun@126.com",:mobilephone=>"11111111111",:examination_id=>@examination.id)
      post :update_exam_rater,:id=>@rater.id,:email=>"wangjun@126.com"
      assigns[:exam_rater].email="er6788@126.com"
      flash[:error].should =~ /be_used/i
    end
    it "should update_exam_rater with a new email " do
      post :update_exam_rater,:id=>@rater.id,:email=>"er6788@163.com",:name=>"qianjun1",:mobilephone=>"15295652460"
      assigns[:exam_rater].name.should =="qianjun1"
      assigns[:exam_rater].email.should =="er6788@163.com"
    end
  end
 
 
end
