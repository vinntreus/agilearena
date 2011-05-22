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
  
  describe "backlog item associations" do
  	before(:each) do
  		@backlog = @user.backlogs.create!(@validParams)
      @b1 = Factory(:backlog_item, :backlog => @backlog, :created_at => 1.day.ago)
      @b2 = Factory(:backlog_item, :backlog => @backlog, :created_at => 1.hour.ago)
  	end
  	
  	  it "should have a backlog items attribute" do
      @backlog.should respond_to(:backlog_items)
    end
    
    it "should have the right backlogs in the right order" do
      @backlog.backlog_items.should == [@b2, @b1]
    end
    
    it "should destroy associated backlogs" do
      @backlog.destroy
      [@b1, @b2].each do |item|
        BacklogItem.find_by_id(item.id).should be_nil
      end
    end
    
  end
  
	describe "private attribute" do

   before(:each) do
			@backlog = @user.backlogs.create!(@validParams)
		end

    it "should respond to private" do
      @backlog.should respond_to(:private)
    end

    it "should not be an private by default" do
      @backlog.should_not be_private
    end

    it "should be convertible to a private" do
      @backlog.toggle!(:private)
      @backlog.should be_private
    end
  end
  
  describe "private backlogs" do
    before(:each) do
			@backlog = @user.backlogs.create!({:title => "fo", :private => true})
		end
  	it "should display for creator" do
				@backlog.can_show_to(@user).should be_true
  	end  
  	
  	it "should not display for not associated user" do
  			@some_user = Factory(:user, :email => "bla@bla.com")

				@backlog.can_show_to(@some_user).should be_false
  	end  
  end
  
  describe "public backlogs" do
    before(:each) do
			@backlog = @user.backlogs.create!({:title => "fo", :private => false})
		end
  	it "should display for creator" do
				@backlog.can_show_to(@user).should be_true
  	end  
  	
  	it "should display for not associated user" do
  			@some_user = Factory(:user, :email => "bla@bla.com")

				@backlog.can_show_to(@some_user).should be_true
  	end  
  
  end
end
