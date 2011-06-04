class BacklogItemsController < ApplicationController
	include ActionView::Helpers::DateHelper

	before_filter :authenticate, :only => [:create, :destroy, :update, :sort]
		
	def create
		@backlog = Backlog.find(params[:backlog_id])		
		@backlog_item = @backlog.backlog_items.build(params[:backlog_item])
		
		authorize! :create, @backlog_item, :message => "Not allowed to create backlogitem"
		
		if @backlog_item.save
			render :json => { :id => @backlog_item.id, :created => time_ago_in_words(@backlog_item.created_at) }	
		else
			render :text => "Could not create backlogitem", :status => 500
    end 

	end	

	def update
  	@backlog_item = BacklogItem.find(params[:id])
		authorize! :update, @backlog_item, :message => "Not allowed to update backlogitem"

    if @backlog_item.update_attributes(params[:backlog_item])
			render :json => { }
    else
			render :text => "Could not update backlogitem", :status => 500
		end
  end
	
	def destroy
		@backlog_item = BacklogItem.find(params[:id])		
		authorize! :destroy, @backlog_item, :message => "Not allowed to delete backlogitem"		
		BacklogItem.delete(params[:id])
		
		render :json => {}
	end
	
	def sort
		@backlog_item = BacklogItem.find(params[:id])		
		authorize! :sort, @backlog_item, :message => "Not allowed to sort backlogitem"		
		
		Backlog.sort_items(@backlog_item, params[:new_parent].to_i)		
		
		render :json => {}
	end
end
