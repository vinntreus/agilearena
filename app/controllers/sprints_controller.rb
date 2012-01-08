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
	
		unless params[:backlogItems].nil?
			@backlog_items = []
			params[:backlogItems].split(",").each do |id|
				@backlog_items.push(BacklogItem.find(id))
			end
			@sprint.add_backlog_items(@backlog_items);
		end

    @sprint.save
    
    render :json => { 
      :id => @sprint.id, 
	    :display_title => @sprint.display_title,
      :display_time => @sprint.display_time
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
