require 'spec_helper'

describe Sprint do
	before(:each) do
		@backlog = Factory(:backlog)
	end
	
	it "should create new instance" do
		@backlog.sprints.create!
	end
end
