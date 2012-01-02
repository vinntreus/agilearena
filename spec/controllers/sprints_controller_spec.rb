require 'spec_helper'

describe SprintsController do
	render_views
	
	describe "GET 'index'" do
		before(:each) do
			@sprint = Factory(:sprint)
			@user = @sprint.backlog.user
      test_sign_in(@user)
		end
		
		it "should display correct title" do
			get :index, :id => @sprint.backlog.id
			response.should have_selector("h1", :content => "Sprints in " + @sprint.backlog.title)
		end
		
		it "should list sprints in backlog" do
			get :index, :id => @sprint.backlog.id
			response.should have_selector("a", :href => "/sprints/" + @sprint.id.to_s,
		                                     :content => @sprint.title)
		end
		
	end
	
	describe "GET 'show'" do
		
		before(:each) do
			@user = test_sign_in(Factory(:user))
	
			@backlog_owner = Factory(:user, :email => "test@tester.com")
  		@backlog = Factory(:backlog, :user => @backlog_owner, :private => true)		
			@sprint = Factory(:sprint, :backlog => @backlog)
			@item = Factory(:backlog_item, :backlog => @backlog, :sprint => @sprint, :title => "something")
	
		end
		
		it "should display correct title" do
			get :show, :id => @sprint
			response.should have_selector("h1", :content => @sprint.title)
		end
		
		it "should display backlog items" do			
			get :show, :id => @sprint
      response.should have_selector("h3", :content => @sprint.backlog_items[0].title)
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
				end.should change(Sprint, :count).by(1)  
		end
	end
	
	describe "POST 'addItemTo'" do
		before(:each) do
			@user = test_sign_in(Factory(:user))
	
			@backlog_owner = Factory(:user, :email => "test@tester.com")
  		@backlog = Factory(:backlog, :user => @backlog_owner)		
			@sprint = Factory(:sprint, :backlog => @backlog)
			
			@item = Factory(:backlog_item, :backlog => @backlog, :title => "something")	
		end
		
		it "should add backlogitem to sprint" do
				lambda do
					post :addItemTo, :id => @sprint.id, :itemId => @item.id
				end.should change(@sprint.backlog_items, :count).by(1)  
		end
		
	end

end
