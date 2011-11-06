class WorkspacesController < ApplicationController

  def show
		@title = "Home"
		if signed_in?
	  	@user = current_user
			id = params[:id]
			if(!id.nil?)
				@user = User.find(id)
			end				

  		@backlogs = @user.backlogs.paginate(:page => params[:page])
	  	@backlog = Backlog.new if signed_in?
	  	
		else 
			redirect_to '/signin'
		end
  end
  
end
