require 'spec_helper'

describe User do
<<<<<<< HEAD

  before(:each)do
    @attr={
		:name=>"example user",
		:email=>"user@example.com",
		:password =>"liyulong",
		:password_confirmation=>"liyulong"
		}
  end
	it "should create a new user" do
		User.create!(@attr)
	end

	describe"password validations"do
		it "should require a password" do
			User.new(@attr.merge(:password=>"", :password_confirmation=>"liyulong")).should_not be_valid
		end

		it "should require a password_confirmation" do
			User.new(@attr.merge(:password=>"invalid")).should_not be_valid
		end

		it "should reject short passwords" do
			short = "a"*5
			User.new(@attr.merge(:password =>short, :password_confirmation =>short)).should_not be_valid
		end
			it "should reject long passwords" do
			long = "a"*21
			User.new(@attr.merge(:password =>long, :password_confirmation =>long)).should_not be_valid
		end

	end
	describe"password encryption"do
		before(:each)do
			@user=User.create!(@attr)

		end

		it "should have an encrypted password" do
		@user.should respond_to(:encrypted_password)
		end

	 end

end
=======
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
>>>>>>> e2a82a915638a11b4951018702a979e1848eb69d
