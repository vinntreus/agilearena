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
      @b1 = Factory(:backlog_item, :backlog => @backlog, :created_at => 1.day.ago, :position => 1)
      @b2 = Factory(:backlog_item, :backlog => @backlog, :created_at => 1.hour.ago, :position => 2)
  	end
  	
 	  it "should have a backlog items attribute" do
      @backlog.should respond_to(:backlog_items)
    end
    
    it "should have a backlog_item_display_id" do
    	@backlog.should respond_to(:backlog_item_next_display_id)
    end
   
    it "should have a backlog_item_display_id set to 1" do
    	@some_backlog = @user.backlogs.create!(@validParams)
    	@some_backlog.backlog_item_next_display_id.should == 1
    end

    
    it "should have the right backlogs in the right order" do
      @backlog.backlog_items.should == [@b1, @b2]
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
  
  describe "tagging items" do
  	it "should be able to tag single category last in title" do
			@backlog = @user.backlogs.create!(@validParams)
			@item = @backlog.backlog_items.create!({:title => "My title #theTag"})

			@item.categories.should include(ActsAsTaggableOn::Tag.new(:name => "theTag"))
  	end
  	
  	it "should be able to tag single category last in title without adding space" do
			@backlog = @user.backlogs.create!(@validParams)
			@item = @backlog.backlog_items.create!({:title => "My title #theTag  "})

			@item.categories.should include(ActsAsTaggableOn::Tag.new(:name => "theTag"))
  	end

  	it "should be able to tag multiple categories without space last in title" do
			@backlog = @user.backlogs.create!(@validParams)
			@item = @backlog.backlog_items.create!({:title => "My title #theTag#onemore"})

			@item.title.should == "My title"
			@item.categories.should include(ActsAsTaggableOn::Tag.new(:name => "theTag"))
			@item.categories.should include(ActsAsTaggableOn::Tag.new(:name => "onemore"))
  	end
  	
  	
  	it "should be able to tag multiple categories with space in title" do
			@backlog = @user.backlogs.create!(@validParams)
			@item = @backlog.backlog_items.create!({:title => "#sometag My #tag title #theTag is cool"})

			@item.title.should == "My title is cool"
			@item.categories.should include(ActsAsTaggableOn::Tag.new(:name => "sometag"))
			@item.categories.should include(ActsAsTaggableOn::Tag.new(:name => "tag"))
			@item.categories.should include(ActsAsTaggableOn::Tag.new(:name => "theTag"))


  	end
  end
  
  describe "total points" do
  	it "should sum items points" do
  		@backlog = @user.backlogs.create!(@validParams)
      @b1 = Factory(:backlog_item, :backlog => @backlog, :points => 2)
      @b2 = Factory(:backlog_item, :backlog => @backlog, :points => 3)
      
      @backlog.total_points.should == 5
  	end
  	
  	it "should handle when points is empty" do
  		@backlog = @user.backlogs.create!(@validParams)
      @b1 = Factory(:backlog_item, :backlog => @backlog, :points => 2)
      @b2 = Factory(:backlog_item, :backlog => @backlog)
      
      @backlog.total_points.should == 2
  	end
  	
  end
 
end
