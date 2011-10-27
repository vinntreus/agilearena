require 'spec_helper'

describe BacklogsController do
	render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "GET 'show' private backlog" do
  
  	describe "logged in user" do  	  		
  	
	  	it "should be successful for creator" do
  			@user = test_sign_in(Factory(:user))
	  		@backlog = Factory(:backlog, :user => @user, :private => true)  			

	  		get :show, :id => @backlog
	  		response.should be_success  			
		  end
		  
		  it "should be successful for members" do
  			@backlog_owner = Factory(:user, :email => "test@tester.com")
  			@user = test_sign_in(Factory(:user))
	  		@backlog = Factory(:backlog, :user => @backlog_owner, :private => true)			
				@coll = Factory(:collaborator, :user => @user, :backlog => @backlog, :role => "member")
				
	  		get :show, :id => @backlog
	  		
	  		response.should be_success  			
		  end
		  
		  it "should redirect for non creator" do
  			@user = test_sign_in(Factory(:user))
  			@backlog_owner = Factory(:user, :email => "test@tester.com")
	  		@backlog = Factory(:backlog, :user => @backlog_owner, :private => true)		  	
		  
	  		get :show, :id => @backlog
	  		response.should redirect_to(signin_path)	  			  	
		  end
		  
      it "should have link to add sprint" do
	      @user = test_sign_in(Factory(:user))
	  		@backlog = Factory(:backlog, :user => @user, :private => true)  	
	    	get :show, :id => @backlog
		   	response.should have_selector("form", :action => sprints_path)
	    end	  
	  end
	  
  end

  
  describe "GET 'show'" do
  
  	before(:each) do
  		@backlog = Factory(:backlog)
 			@user = test_sign_in(Factory(:user, :email => "someuser@test.com"))
  	end
  
  	it "should be successful" do
  		get :show, :id => @backlog
  		response.should be_success
  	end
  	
  	it "should find right user" do
  		get :show, :id => @backlog
			assigns(:backlog).should == @backlog
  	end
  	
  	it "should have the right title" do
      get :show, :id => @backlog
      response.should have_selector("title", :content => @backlog.title)
    end
  
    
		it "should show the backlog items" do
      b1 = Factory(:backlog_item, :backlog => @backlog, :title => "Foo bar")
      b2 = Factory(:backlog_item, :backlog => @backlog, :title => "Baz quux")
      get :show, :id => @backlog
      response.should have_selector("h3", :content => b1.title)
      response.should have_selector("h3", :content => b2.title)
    end     
    
    it "should not have link to add sprint" do
    	get :show, :id => @backlog
	   	response.should_not have_selector("form", :action => sprints_path)
    end
    
    it "should have list of sprints" do
	    sprint = Factory(:sprint, :backlog => @backlog, :title => "1")
			get :show, :id => @backlog
			response.should have_selector("a", :content => sprint.display_title)
    end
    
		it "should have form to create backlogitem for members" do
			@backlog_owner = Factory(:user, :email => "test@tester.com")
  		@backlog = Factory(:backlog, :user => @backlog_owner, :private => true)			
			@coll = Factory(:collaborator, :user => @user, :backlog => @backlog, :role => "member")
			
  		get :show, :id => @backlog
  		
			response.should have_selector("form", :action => backlog_items_path)
		end
  	
  end
  
  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :title => "" }
      end

      it "should not create a backlog" do
        lambda do
          post :create, :backlog => @attr
        end.should_not change(Backlog, :count)
      end

      it "should redirect to the home page" do
        post :create, :backlog => @attr
				flash[:error].should =~ /Could not create backlog!/i
        response.should redirect_to root_path
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :title => "Lorem ipsum" }
      end

      it "should create a backlog" do
        lambda do
          post :create, :backlog => @attr
        end.should change(Backlog, :count).by(1)
      end

      it "should redirect to the backlog page" do
        post :create, :backlog => @attr
        response.should redirect_to(backlog_path(assigns(:backlog)))
      end

      it "should have a flash message" do
        post :create, :backlog => @attr
        flash[:success].should =~ /backlog created/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    describe "success" do
      before(:each) do 
          @backlog = Factory(:backlog)
           @user = @backlog.user
           test_sign_in(@user)
      end
      
      it "should succeed when user is allowed to delete backlog" do

           
           lambda do
            delete :destroy, :id => 1
           end.should change(Backlog, :count).by(-1)
      end
    end
    
    describe "failure" do
      
      before(:each) do 
          @backlog = Factory(:backlog)
           @user = @backlog.user
           test_sign_in(@user)
      end
      
      it "should fail when trying to delete backlog with another user" do
          @some_user = Factory(:user, :email => "fkkhgyhl@test.com")
           @some_backlog = Factory(:backlog, :user => @some_user, :id => 5)

           delete :destroy, :id => 5
           response.body.should =~ /not allowed to delete backlog/i
           response.status.should == 403
      end
      
    end
    
  end

end

