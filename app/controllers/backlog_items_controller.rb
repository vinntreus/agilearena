class BacklogItemsController < ApplicationController
	include ActionView::Helpers::DateHelper

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
			render :json => { :id => @backlog_item.id, :created => time_ago_in_words(@backlog_item.created_at) }
			#flash[:success] = "Created backlogitem"
			#respond_to do |format|
			#	format.html redirect_to @backlog
			#	format.json { render :json => @backlog_item }
			#end

		else
			render :json => { :error => "Could not create backlogitem" }
      #flash[:error] = "Could not create backlogitem!"
      #redirect_to root_path
    end
    


	end
	
	def destroy
		BacklogItem.delete(params[:id])

		render :json => {}
	end
end
