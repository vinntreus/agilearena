class WorkspacesController < ApplicationController

  def show
    @title = "Home"
    if signed_in?      
      id = params[:id]      

      @user = id == nil ? current_user : User.find(id)

      @backlogs_created = @user.backlogs
      @backlogs_collaborating_on = Backlog.joins(:collaborators).where(:collaborators => {:user_id => @user}).where("backlogs.user_id != ?", @user.id)
      @backlog = Backlog.new
    else 
      redirect_to '/signin'
    end
  end
  
end
