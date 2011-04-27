require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      
      :email => "user@example.com",
      :password => "user"
      
    }
  end
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
  end
  
  it "should reject short passwords" do
		short = "a" * 5
		User.new(@attr.merge(:password => short, :password_confirmation => short)).should_not be_valid
	end
  it "should reject long passwords" do
		long = "a" * 41
		User.new(@attr.merge(:password => long, :password_confirmation => long)).should_not be_valid
	end

end
