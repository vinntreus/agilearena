require 'spec_helper'

describe BacklogItemsController do
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
  
  describe "POST 'create'" do

    before(:each) do
			@backlog = Factory(:backlog)
      @user = @backlog.user
      test_sign_in(@user)
      @b_id = @backlog.id
    end

    describe "failure" do

      before(:each) do
        @attr = { :title => "" }

      end

      it "should not create a backlog" do
        lambda do
          post :create, :backlog_item => @attr, :backlog_id => @b_id
        end.should_not change(BacklogItem, :count)
      end
      
      it "should return error message" do
        post :create, :backlog_item => @attr, :backlog_id => @b_id
				response.body.should =~ /Could not create backlogitem/i
				response.status.should == 500
      end
      
       it "should return 403 when not allowed" do
       	@some_user = Factory(:user, :email => "fl@test.com")
       	@some_backlog = Factory(:backlog, :user => @some_user)
       	
        post :create, :backlog_item => @attr, :backlog_id => @some_backlog.id
				response.body.should =~ /Not allowed to create backlogitem/i
				response.status.should == 403
      end

    end
    
     describe "success" do

      before(:each) do
        @attr = { :title => "Lorem ipsum" }
      end

      it "should create a backlogitem" do
        lambda do
          post :create, :backlog_item => @attr, :backlog_id => @b_id
        end.should change(BacklogItem, :count).by(1)
      end

      it "should return backlog item id" do
        post :create, :backlog_item => @attr, :backlog_id => @b_id
        parsed_body = JSON.parse(response.body)
        parsed_body["id"].should == 1
        parsed_body["created"].should =~ /less than a minute/i
      end
      
    end

  end

end
