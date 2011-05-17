class BacklogItemsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	
	def create
		@backlog = Backlog.find(params[:backlog_id])
		if @backlog.user != current_user
      flash[:error] = "Not allowed to create backlogitem!"
      redirect_to root_path			
      return
		end
		
		@backlog_item = @backlog.backlog_items.build(params[:backlog_item])
		
		if @backlog_item.save
			flash[:success] = "Created backlogitem"
			redirect_to @backlog
		else
      flash[:error] = "Could not create backlogitem!"
      redirect_to root_path
    end
	end
	
	def destroy
	end
end
