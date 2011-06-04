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

		@current_item = BacklogItem.find(params[:id])		
		@current_position = @current_item.position
		if params[:new_parent].to_i < 1
			BacklogItem.where("backlog_id = ? and position < ?",@current_item.backlog_id, @current_position).each do |item|
				item.position += 1
				item.save
			end
			@current_item.position = 1
			@current_item.save
		else
		
			@new_parent = BacklogItem.find(params[:new_parent])		

		
			if @new_parent != nil
				@parent_position = @new_parent.position
		
				if(@parent_position < @current_position)
					BacklogItem.where(:backlog_id => @current_item.backlog_id, :position => (@parent_position + 1)..@current_position).each do |item|
						item.position += 1
						item.save
					end
					@current_item.position = @parent_position + 1
				else
					BacklogItem.where(:backlog_id => @current_item.backlog_id, :position => @current_position..(@parent_position)).each do |item|
						item.position -= 1
						item.save
					end				
					@current_item.position = @parent_position
				end

				@current_item.save			
			end
		end
		
	render :json => {}

	end
end
