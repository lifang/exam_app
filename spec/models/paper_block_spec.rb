require 'spec_helper'

describe PaperBlock do
  before(:each) do
    @paper = Factory.create(:paper, :paper_url => "/papers/1.xml")
    @paper_block = Factory.create(:paper_block, :paper_id => @paper.id)
  end
  it "should create a new paper_block" do
    PaperBlock.should have(1).record
  end

  it "should write paper_block xml" do
    @paper_block.paper = @paper
    @paper_block.create_block_xml("#{Rails.root}/public" + @paper.paper_url)
  end

  it "should delete a paper_block" do
    @paper_block = PaperBlock.first
    lambda{
      @paper_block.delete_block_xml
      @paper_block.destroy
      }.should change(PaperBlock, :count).by(-1)
  end
end
