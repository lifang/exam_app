require 'spec_helper'

describe User::CollectionsController do
  before(:each) do
    @user = Factory(:user)
    @collection = Collection.create(:user_id => @user.id, :collection_url => "/collections/1.xml")
  end

  it "should open a xml" do
    cookies[:user_id] = @user.id
    get :index, :user_id => @user.id
    assigns[:doc].should_not be_nil
  end

  it "should not open a xml" do
    @user1 = Factory(:user)
    @collection1 = Collection.create(:user_id => @user1.id)
    get :index, :user_id => @user1.id
    flash[:warn].should =~ /clear/i
  end

  it "should return collection xml" do
    post :search, :user_id => @user.id, :tag => "", :category => 2
    assigns[:doc].should_not be_nil
    assigns[:doc].to_s.should_not == ""
  end

  it "should add problem to xml" do
    @problem_id = "121"
    @problem_xml = <<-XML
      <problem id='121' score='5' types='0'>
          <title>______ is your name?</title>
          <category>2</category>
          <complete_title>[[what|where;when;why||mm]] is your name?[(5)][{xx}]</complete_title>
          <questions>
              <question correct_type='0' id='149' score='5' user_answer='what' user_score='5'>
                  <answer>what</answer>
                  <analysis>xixi</analysis>
                  <questionattrs>what;-;where;-;when;-;why</questionattrs>
                  <tags>mm</tags>
              </question>
          </questions>
      </problem>
    XML
    @exam_user = ExamUser.create(:paper_id => 1, :examination_id => 1, :user_id => @user.id)
    post :create, :problem_id => @problem_id, :problem_content_121 => @problem_xml, :paper_id => @exam_user.paper_id,
      :examination_id => @exam_user.examination_id, :user_id => @user.id
    flash[:notice] =~ /collect/i
  end
end
