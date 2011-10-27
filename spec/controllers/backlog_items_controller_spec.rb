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
    
    it "should deny access to 'update'" do
      put :update, :id => 1
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'sort'" do
      put :sort, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "PUT 'sort'" do

  	before(:each) do
			@backlog = Factory(:backlog)
			@backlog_item = Factory(:backlog_item, :position => 1, :id => 1, :title => "hej", :backlog => @backlog)
			@backlog_item2 = Factory(:backlog_item, :position => 2, :id => 2, :title => "da", :backlog => @backlog)
	  	@backlog_item3 = Factory(:backlog_item, :position => 3, :id => 3, :title => "c", :backlog => @backlog)
			@backlog_item4 = Factory(:backlog_item, :position => 4, :id => 4, :title => "d", :backlog => @backlog)
	
			@user = @backlog.user
			test_sign_in(@user)  		
		end
		
		it "should have form to create backlogitem for members" do
			@backlog_owner = Factory(:user, :email => "test@tester.com")
  		@backlog2 = Factory(:backlog, :user => @backlog_owner, :private => true)			
			@coll = Factory(:collaborator, :user => @user, :backlog => @backlog2, :role => "member")
			
			@backlog_item5 = Factory(:backlog_item, :position => 1, :id => 5, :title => "c", :backlog => @backlog2)
			@backlog_item6 = Factory(:backlog_item, :position => 2, :id => 6, :title => "d", :backlog => @backlog2)
			
  		put :sort, :id => 5, :new_parent => 6
			@backlog_item5.reload
			@backlog_item5.position.should == 2
		end
  	
  	it "should increment position when downprioritized" do
			put :sort, :id => 1, :new_parent => 2
			@backlog_item.reload
			@backlog_item.position.should == 2
  	end  	
  	
  	it "should decrement position when downprioritized" do
			put :sort, :id => 1, :new_parent => 2
			@backlog_item2.reload
			@backlog_item2.position.should == 1
  	end  	
  	
  	it "should update position for all affected items when sorting upwards" do
			put :sort, :id => 4, :new_parent => 1
			@backlog_item.reload
			@backlog_item2.reload
			@backlog_item3.reload
			@backlog_item4.reload
			
			@backlog_item.position.should == 1
			@backlog_item4.position.should == 2
			@backlog_item2.position.should == 3
			@backlog_item3.position.should == 4
  	end  	
  	
  	it "should update position for all affected items when sorting downwards" do
			put :sort, :id => 1, :new_parent => 4
			@backlog_item.reload
			@backlog_item2.reload
			@backlog_item3.reload
			@backlog_item4.reload

			@backlog_item2.position.should == 1
			@backlog_item3.position.should == 2
			@backlog_item4.position.should == 3
			@backlog_item.position.should == 4
  	end  	

  	it "should update position for all affected items when putting item on top" do
			put :sort, :id => 3, :new_parent => 0
			@backlog_item.reload
			@backlog_item2.reload
			@backlog_item3.reload
			@backlog_item4.reload

			@backlog_item3.position.should == 1
			@backlog_item.position.should == 2
			@backlog_item2.position.should == 3
			@backlog_item4.position.should == 4
  	end  	

  	
  end
  
  describe "DELETE 'destroy'" do
  	
  	describe "failure" do
  	
			before(:each) do
				@backlog = Factory(:backlog)
				@backlog_item = Factory(:backlog_item, :id => 1, :title => "hej", :backlog => @backlog)
				@user = @backlog.user
				test_sign_in(@user)  		
			end
  	
  		it "should fail when not allowed to" do
  			@some_user = Factory(:user, :email => "fl@test.com")
       	@some_backlog = Factory(:backlog, :user => @some_user)
       	@some_backlog_item = Factory(:backlog_item, :backlog => @some_backlog, :id => 2)

	  		delete :destroy, :id => 2
  			response.body.should =~ /not allowed to delete backlogitem/i
  			response.status.should == 403
  		end
  	end
  	
  	describe "success" do
  		before(:each) do
				@backlog = Factory(:backlog)
				@backlog_item = Factory(:backlog_item, :id => 1, :title => "hej", :backlog => @backlog)
				@user = @backlog.user
				test_sign_in(@user)  		
			end
			
			it "should delete" do
	  		lambda do
          post :destroy, :id => 1
        end.should change(BacklogItem, :count).by(-1)
			end
			
				
			it "members can delete" do
				@backlog_owner = Factory(:user, :email => "test@tester.com")
				@backlog2 = Factory(:backlog, :user => @backlog_owner, :private => true)			
				@backlog_item2 = Factory(:backlog_item, :id => 2, :title => "hej", :backlog => @backlog2)
				@coll = Factory(:collaborator, :user => @user, :backlog => @backlog2, :role => "member")
				
				lambda do
          post :destroy, :id => 2
        end.should change(BacklogItem, :count).by(-1)
        
			end
  	end
  	
  end
  
  describe "PUT 'update'" do
  	before(:each) do
  		@backlog = Factory(:backlog)
  		@backlog_item = Factory(:backlog_item, :id => 1, :title => "hej", :backlog => @backlog)
  		@member = Factory(:user, :email => "flu@test.com")
			@collaborator = Factory(:collaborator, :backlog => @backlog, :user => @member)
  		@user = @backlog.user
  		test_sign_in(@user)  		
  	end

  	describe "failure" do

  		it "should not update when empty title" do
  			@attr = {:title => ""}
        put :update,:id => 1, :backlog_item => @attr, :backlog_id => @backlog.id
        @backlog_item.reload
				@backlog_item.title.should == "hej"
  		end
  		
  		it "should not update when not allowed" do
  			@some_user = Factory(:user, :email => "fl@test.com")
       	@some_backlog = Factory(:backlog, :user => @some_user)
       	@some_backlog_item = Factory(:backlog_item, :backlog => @some_backlog, :id => 2)

  			@attr = {:title => "d"}
  			
        put :update,:id => 2, :backlog_item => @attr, :backlog_id => @some_backlog.id
        
        @backlog_item.reload
				@backlog_item.title.should == "hej"
				response.status.should == 403
  		end
  		
  	end
  	
  	describe "success" do

  		it "should update title" do
  			@attr = {:title => "a"}
        put :update,:id => 1, :backlog_item => @attr, :attrbacklog_id => @backlog.id
        @backlog_item.reload
				@backlog_item.title.should == "a"
  		end
		  it "member can create" do
	    	test_sign_in(@member)
	    	
	    	@attr = {:title => "a"}
        put :update,:id => 1, :backlog_item => @attr, :attrbacklog_id => @backlog.id
        @backlog_item.reload
				@backlog_item.title.should == "a"
    	end
  	end
  end
  
  describe "POST 'create'" do

    before(:each) do
			@backlog = Factory(:backlog)
			@member = Factory(:user, :email => "flu@test.com")
			@collaborator = Factory(:collaborator, :backlog => @backlog, :user => @member)
      @user = @backlog.user
      test_sign_in(@user)
      @b_id = @backlog.id
    end

    describe "failure" do

      before(:each) do
        @attr = { :title => "" }

      end

      it "should not create a backlog item" do
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
      
      it "member can create" do
      	test_sign_in(@member)
      	
        lambda do
          post :create, :backlog_item => @attr, :backlog_id => @b_id
        end.should change(BacklogItem, :count).by(1)

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
      end
      
      it "should return backlog item created" do
        post :create, :backlog_item => @attr, :backlog_id => @b_id
        parsed_body = JSON.parse(response.body)
        parsed_body["created"].should =~ /less than a minute/i
      end

      
    end

  end

end
