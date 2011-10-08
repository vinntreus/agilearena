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

end
