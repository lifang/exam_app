require 'spec_helper'

describe Tag do
  before(:each) do
    @tag = Tag.create(:name => "tag1", :num => 2)
  end

  it "should return 2 and 3" do
    lambda{
      @tags = Tag.create_tag(["tag1", "tag2"])
      @tags[1].num.should == 3
      }.should change(Tag, :count).by(1)
  end

end
