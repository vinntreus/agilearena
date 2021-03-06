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
	
	it "should default status to Todo" do
		@backlog_item =	@backlog.backlog_items.create!(@validParams)
		@backlog_item.status.should == "Todo"
	end
	
	describe "position" do
		before(:each) do
			@item = @backlog.backlog_items.create!(@validParams)
		end

		it "should set to 1 when no existing items" do
      @item.position.should == 1
    end
    
    it "should set to 2 when one item" do
 			@item2 = @backlog.backlog_items.create!(@validParams)
      @item2.position.should == 2
    end
		
	end
	
		
	describe "display_id" do
		before(:each) do			
			@item = @backlog.backlog_items.create!(@validParams)
		end

		it "should set to 1 when no existing items" do
      @item.display_id.should == 1
      @backlog.reload
      @backlog.backlog_item_next_display_id.should == 2
    end
    
    it "should set to 2 when one item" do
 			@item2 = @backlog.backlog_items.create!(@validParams)
      @item2.display_id.should == 2
      @backlog.reload
      @backlog.backlog_item_next_display_id.should == 3
    end
		
	end
	
	describe "tags" do
		before(:each) do
			@item = @backlog.backlog_items.create!(@validParams)
		end

		it "should have all tag types" do
      @item.tag_types.should == [:categories]
    end
	end
	
	describe "backlog associations	" do
	
		before(:each) do
			@item = @backlog.backlog_items.create!(@validParams)
		end

		it "should have a backlog attribute" do
      @item.should respond_to(:backlog)
    end
    
    it "should have display_id" do
    	@item.should respond_to(:display_id)
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
