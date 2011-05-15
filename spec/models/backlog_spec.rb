require 'spec_helper'

describe Backlog do
	before(:each) do
		@user = Factory(:user)
		@validParams = {
			:title => "test"
		}
	end
	it "should create new instance" do
		@user.backlogs.create!(@validParams)
	end
	
	describe "user associations	" do
	
		before(:each) do
			@backlog = @user.backlogs.create!(@validParams)
		end

		it "should have a user attribute" do
      @backlog.should respond_to(:user)
    end

    it "should have the right associated user" do
      @backlog.user_id.should == @user.id
      @backlog.user.should == @user
    end
    
    describe "validations" do
    	it "should require a user id" do
		    Backlog.new(@validParams).should_not be_valid
		  end

		  it "should require nonblank content" do
		    @user.backlogs.build(:title => "  ").should_not be_valid
		  end

		  it "should reject long content" do
		    @user.backlogs.build(:title => "a" * 101).should_not be_valid
		  end
    end
  
  end  
end
