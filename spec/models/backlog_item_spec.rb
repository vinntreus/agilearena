require 'spec_helper'

describe BacklogItem do
  before(:each) do
		@backlog = Factory(:backlog)
		@validParams = {
			:title => "test"
		}
	end
	
	it "should create new instance" do
		@backlog.backlog_items.create!(@validParams)
	end
	
	describe "backlog associations	" do
	
		before(:each) do
			@item = @backlog.backlog_items.create!(@validParams)
		end

		it "should have a backlog attribute" do
      @item.should respond_to(:backlog)
    end

    it "should have the right associated user" do
      @item.backlog_id.should == @backlog.id
      @item.backlog.should == @backlog
    end
    
    describe "validations" do
    	it "should require a user id" do
		    BacklogItem.new(@validParams).should_not be_valid
		  end

		  it "should require nonblank content" do
		    @backlog.backlog_items.build(:title => "  ").should_not be_valid
		  end

		  it "should reject long content" do
		    @backlog.backlog_items.build(:title => "a" * 201).should_not be_valid
		  end
    end  
  end  
	
end
