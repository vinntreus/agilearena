require 'spec_helper'

describe SprintsController do
	render_views
	
	describe "GET 'show'" do
		
		before(:each) do

			@sprint = Factory(:sprint)
			@user = @sprint.backlog.user
      test_sign_in(@user)
		end
		
		it "should display correct title" do
			get :show, :id => @sprint
			response.should have_selector("h1", :content => @sprint.title)
		end
		
	end

  describe "POST 'create'" do
  	before(:each) do
			@backlog = Factory(:backlog)
      @user = @backlog.user
      test_sign_in(@user)
      @b_id = @backlog.id
    end
  
    it "should be successful" do
				lambda do
					post :create, :backlog_id => @b_id
				end.should change(Sprint, :count).by(1)  end
	  end

end
