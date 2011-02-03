require 'spec_helper'

describe SessionsController do
	render_views

  describe "GET 'new'" do
  
    it "should be successful" do
      get :new
      response.should be_success
    end
    
     it "should have the right title" do
      get :new
      response.should render_template 'sessions/new'
      response.should have_selector("title", :content => "Sign in")
    end
        
  end
  
  describe "POST 'create'" do
  
		describe "signing in" do
			
			it "should authenticate by params" do
				User.should_receive(:authenticate).once.with("mail", "pass")
				post :create, :session => {:email => "mail", :password => "pass"}
			end
			
		end
		
		describe "failure signing in" do
			
			before(:each) do
				@attr = {:email => "bla@bla.com", :password => "notvalid"}
			end
		
			it "should render 'new' view" do
				post :create, :session => @attr
				response.should render_template 'sessions/new'
			end
		
			it "should render flash" do
				post :create, :session => @attr
				flash.now[:error].should =~ /invalid/i
			end

		end
		
		describe "successful sign in" do
				before(:each) do
					@attr = {:email => "bla@bla.com", :password => "valid"}
					@user = Factory.build(:user)
					@user.id = 1
					User.stub!(:authenticate).and_return(@user)
				end
		
				it "should redirect to user" do
					post :create, :session => @attr
					response.should redirect_to user_path(@user)
				end
				
				it "should sign in user" do
					controller.should_receive(:sign_in).with(@user)
					post :create, :session => @attr					
				end		
				
				it "should store the signed in user" do
	        post :create, :session => @attr
	        controller.current_user.should == @user
	        controller.should be_signed_in
	      end
			
		end
		
		describe "DELETE 'destroy'" do

		  it "should sign a user out" do
		    test_sign_in(Factory(:user))
		    controller.should be_signed_in
		    
		    delete :destroy
		    controller.should_not be_signed_in
		    response.should redirect_to(root_path)
		  end
		  
		end
  
	end
end
