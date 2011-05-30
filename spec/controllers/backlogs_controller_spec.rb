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
		  
		  it "should redirect for non creator" do
  			@user = test_sign_in(Factory(:user))
  			@backlog_owner = Factory(:user, :email => "test@tester.com")
	  		@backlog = Factory(:backlog, :user => @backlog_owner, :private => true)		  	
		  
	  		get :show, :id => @backlog
	  		response.should redirect_to(signin_path)	  	
		  	
		  end
	  
	  end
	  
  end

  
  describe "GET 'show'" do
  
  	before(:each) do
  		@backlog = Factory(:backlog)
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

    it "should include the name" do
      get :show, :id => @backlog
      response.should have_selector("h1", :content => @backlog.title)
    end 
    
     it "should show the backlog items" do
      b1 = Factory(:backlog_item, :backlog => @backlog, :title => "Foo bar")
      b2 = Factory(:backlog_item, :backlog => @backlog, :title => "Baz quux")
      get :show, :id => @backlog
      response.should have_selector(".title", :content => b1.title)
      response.should have_selector(".title", :content => b2.title)
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
end