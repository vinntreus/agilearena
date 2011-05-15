class BacklogsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	
	def create
		@backlog  = current_user.backlogs.build(params[:backlog])
    if @backlog.save
      flash[:success] = "Backlog created!"
      redirect_to @backlog
    else
      flash[:error] = "Could not create backlog!"
      redirect_to root_path
    end
	end
	
	def show
  	@backlog = Backlog.find(params[:id])
  	@title = @backlog.title
  end
	
	def destroy
	end
	
end
