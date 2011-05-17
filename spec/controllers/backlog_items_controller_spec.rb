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
      
      it "should redirect to the home page" do
        post :create, :backlog_item => @attr, :backlog_id => @b_id
				flash[:error].should =~ /Could not create backlogitem!/i
        response.should redirect_to root_path
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

      it "should redirect to the backlog page" do
        post :create, :backlog_item => @attr, :backlog_id => @b_id
        response.should redirect_to(backlog_path(assigns(:backlog)))
      end

      it "should have a flash message" do
        post :create, :backlog_item => @attr, :backlog_id => @b_id
        flash[:success].should =~ /Created backlogitem/i
      end
    end

  end

end
