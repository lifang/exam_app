require 'spec_helper'

describe Category do
  before(:each) do
    @attr={:name => "english", :parent_id => 0}
  end

  it "should create a new category" do
    Category.create!(@attr)
  end

  it "should a exists name" do
    Category.create!(@attr)
    if Category.is_exists?("english")
      Category.create!(@attr.merge(:name => "chinese", :parent_id => 1))
    end
    Category.should have(2).records
  end

  it "return category level" do
    @category = Factory(:category)
    @level = Category.level(@category)
    @level.should == 0
  end

  it "should has son" do
    @category = Factory(:category)
    Category.create!(@attr.merge(:name => "chinese", :parent_id => @category.id))
    @category.is_have_son?.should be true
  end

end
