require 'spec_helper'

describe Sprint do
	before(:each) do
		@backlog = Factory(:backlog)
	end
	
	it "should create new instance" do
		@backlog.sprints.create!
	end
	
	describe "display title when title is not a number" do
		it "should display title" do
			sprint = Factory(:sprint, :backlog => @backlog, :title => "some title")
			sprint.display_title.should == "some title"
		end
	end
	
	describe "display title when title is a number" do
		it "should display with special format" do
			sprint = Factory(:sprint, :backlog => @backlog, :title => "2")
			sprint.display_title.should == "Sprint #2"
		end
	end

	describe "backlog items" do
		it "adding one should append one" do
			sprint = Factory(:sprint, :backlog => @backlog, :title => "2")
			backlog_item = Factory(:backlog_item, :position => 1, :id => 1, :title => "hej", :backlog => @backlog)

			sprint.add_backlog_items([backlog_item])
			
			sprint.backlog_items.count.should == 1						
		end

		it "adding two should append two" do
			sprint = Factory(:sprint, :backlog => @backlog, :title => "2")
			backlog_item = Factory(:backlog_item, :position => 1, :id => 1, :title => "hej", :backlog => @backlog)
			backlog_item2 = Factory(:backlog_item, :position => 2, :id => 2, :title => "hej2", :backlog => @backlog)

			sprint.add_backlog_items([backlog_item, backlog_item2])
			
			sprint.backlog_items.count.should == 2
		end
	end

end
