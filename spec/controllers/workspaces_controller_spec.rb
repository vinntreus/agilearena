require 'spec_helper'

describe WorkspacesController do
  render_views
  
  describe "GET 'show'" do
    it "should be redirect when not logged in" do
      get 'show'
      response.should be_redirect
    end	
		
  end
  
  describe "GET 'show' when signed in" do		
			it "should render view 'show'" do
				test_sign_in(Factory(:user))
				get 'show'
		    response.should be_success
	      response.should render_template "show"
			end					
	end
end		
