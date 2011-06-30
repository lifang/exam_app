require 'spec_helper'
describe PapersController do
  render_views
  before(:each) do
    @category = Category.create(:name => "test category", :parent_id => 0)
    @paper = Factory.create(:paper, :paper_url => "/papers/104.xml")
  end

  describe "Post 'change_info'" do
    before(:each) do
      @info = {:title => "paper test title", :description => "paper test description"}
    end

    it "should change paper base info" do
      post :change_info, :id => @paper.id, :info => @info, :category => @category.id
      response.should redirect_to(new_step_two_paper_path(@paper))
    end
  end

  describe "Get 'show'" do
    it "should open a paper" do
      get :show, :id => 2
      flash.now[:error].should =~ /some/i
    end
  end

  describe "Post 'create step one'" do
    it "should create a new paper" do
      cookies[:user_id] = 1
      @paper = {:title => "paper test2", :description => "paper description2"}
      post :create_step_one, :paper => @paper, :category => @category.id
      #response.should redirect_to(new_step_two_paper_path(@paper))
      Paper.should have(2).records
    end
  end

  describe "Post search paper" do
    it "should have two records" do
      @paper1 = Factory.create(:paper)
      @paper2 = Factory.create(:paper)
      cookies[:user_id] = "1"
      session[:category] = "1"
      get :search_list, :user_id => "1", :category => "1", :page => 1
      assigns[:papers].size.should == 3
    end
  end

  describe "Get 'create paper js'" do
    it "should create a paper js" do
      get :create_all_paper, :id => @paper.id
      response.should redirect_to(papers_path)
    end
  end

end
