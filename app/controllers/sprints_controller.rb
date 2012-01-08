class SprintsController < ApplicationController
  
  def index
    @backlog = Backlog.find(params[:id])
    @sprints = @backlog.sprints
  end
  
  def show
    @sprint = Sprint.find(params[:id])		
    @backlog_items = @sprint.backlog_items
  end
  
  def create
    @backlog = Backlog.find(params[:backlog_id])
    @sprint =	@backlog.sprints.new(params[:sprint])		
		@backlogitemsIds = params[:backlogItems].split(",")
		
		@backlogitemsIds.each do |item_id|
			@backlog_item = BacklogItem.find(item_id)    
    	@sprint.backlog_items.push(@backlog_item);
		end

    @sprint.save		
    
    render :json => { 
      :id => @sprint.id, 
	    :title => @sprint.display_title,
      :time => @sprint.display_time
    }
  end  
  
  def addItemTo
    @sprint = Sprint.find(params[:id])
    @backlog_item = BacklogItem.find(params[:itemId])
    
    @sprint.backlog_items.push(@backlog_item);
    @sprint.save!
    
    render :json => { :title => @sprint.display_title}  	
  end
  
end
