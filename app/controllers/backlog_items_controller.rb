class BacklogItemsController < ApplicationController
	include ActionView::Helpers::DateHelper

	before_filter :authenticate, :only => [:create, :destroy]
	
	def create
		@backlog = Backlog.find(params[:backlog_id])

		if @backlog.user != current_user
			render :text => "Not allowed to create backlogitem", :status => 403
      return
		end
		
		@backlog_item = @backlog.backlog_items.build(params[:backlog_item])
		
		if @backlog_item.save
			render :json => { :id => @backlog_item.id, :created => time_ago_in_words(@backlog_item.created_at) }	
		else
			render :text => "Could not create backlogitem", :status => 500
    end 

	end
	
	#missing tests
	def update
  	 @backlogitem = BacklogItem.find(params[:id])
  	 
    if @backlogitem.update_attributes(params[:backlog_item])
			render :json => { }
    else
			render :text => "Could not update backlogitem", :status => 500
		end

  end
	
	def destroy
		@backlog_item = BacklogItem.find(params[:id])
		if(@backlog_item.is_allowed_to_delete current_user)
			BacklogItem.delete(params[:id])
			render :json => {}
		else
			render :text => "Could not delete", :status => 403
		end
	end
end
