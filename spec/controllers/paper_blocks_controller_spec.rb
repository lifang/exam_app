require 'spec_helper'

describe PaperBlocksController do
  it "should load create problem" do
    post :load_create_problem, :paper_id => "1", :block_id => "32", :type => "create"
    assigns[:xml].to_s.should_not == ""
    response.should render_template("new_question")
  end

  it "should load mavin problem" do
    post :load_create_problem, :paper_id => "1", :block_id => "32", :type => "mavin"
    assigns[:xml].to_s.should_not == ""
    response.should render_template("mavin_question")
  end

  it "should load edit problem" do
    post :load_edit_problem, :paper_id => "1", :block_id => "32", :problem_id => "70"
    assigns[:xml].to_s.should_not == ""
    response.should render_template("edit_problem")
  end

  it "should load single choose" do
    post :choose_type, :id => "32", :paper_id => "1", :question_type => "0"
    response.should render_template("single_choose")
  end

end
