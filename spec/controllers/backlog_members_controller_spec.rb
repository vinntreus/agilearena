require 'spec_helper'

describe BacklogMembersController do
	render_views
		describe "access control" do
			it "should deny access to 'show'" do
				get :show, :id => 1
				response.should redirect_to(signin_path)
			end
		end
		describe "GET 'show'" do

			before(:each) do				
				@member = Factory(:user, :email => "member@test.com")
				@backlog_owner = Factory(:user, :email => "test@tester.com")
	  		@backlog = Factory(:backlog, :user => @backlog_owner, :private => true)							
				@coll = Factory(:collaborator, :user => @member, :backlog => @backlog, :role => "member")	

				test_sign_in(@backlog_owner)  		
			end
			
			it "Should display member info" do
				get :show, :id => 1
				
				response.should have_selector("li", :content => "member@test.com")
			end
			
			describe "failure" do
				it "should fail for non member on private backlog" do
					@not_member = Factory(:user, :email => "not_member@test.com")
					test_sign_in(@not_member)
					
					get :show, :id => 1
					
					response.should redirect_to(signin_path)
					
				end
			end
			
			
		end
end
