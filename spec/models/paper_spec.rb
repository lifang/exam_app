require 'spec_helper'

describe Paper do
  before(:each) do
    @paper = Factory(:paper)
  end
  
  it "should create a new record" do
    lambda{
      Paper.create!(@paper)
      }.should change(Paper, :count).by(1)
  end

  it "should generate baseinfo xml" do
    @content = @paper.xml_content
    @paper.create_paper_url(@paper.xml_content, 'papers', 'xml')
    @content.should_not be_nil
    @paper.paper_url.should_not be_nil
  end

  it "should update base info" do
    @paper.paper_url = "/papers/25.xml"
    @paper.update_base_info("#{Rails.root}/public" + @paper.paper_url)
    @paper.paper_url.should_not be_nil
  end

end
