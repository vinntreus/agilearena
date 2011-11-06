require 'spec_helper'

describe PagesController do
  render_views
  
  
  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
	
		it "should have right title" do
			get 'contact'
			response.should have_selector("title", :content => "| Contact")
		end
  end
  
  describe "GET 'about'" do
		it "should be successfull" do
			get 'about'
			response.should be_success
		end
	
		it "should have right title" do
			get 'about'
			response.should have_selector("title", :content => "| About")
		end
  end
  
  describe "GET 'help'" do
		it "should be successful" do
			get 'help'
			response.should be_success
		end
	
		it "should have right title" do
			get 'help'
			response.should have_selector("title", :content => "| Help")
		end
  end

end
