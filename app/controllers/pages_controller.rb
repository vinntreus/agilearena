class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?
      @user = current_user
      @backlogs = @user.backlogs.paginate(:page => params[:page])
      @backlog = Backlog.new if signed_in?
      render "home_signedin"
    else 
      redirect_to '/signin'
    end
  end
  
  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
  
end
