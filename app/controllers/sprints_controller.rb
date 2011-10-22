class SprintsController < ApplicationController

	def index
		@backlog = Backlog.find(params[:id])
		@sprints = @backlog.sprints
	end

	def show
		@sprint = Sprint.find(params[:id])		
	end

  def create
  	@backlog = Backlog.find(params[:backlog_id])
		@sprint =	@backlog.sprints.create!
  	
  	render :json => { 
  										:id => @sprint.id, 
  										:title => @sprint.display_title 
  									}
  	#redirect_to @sprint
  end
  
  def addItemTo
  	@sprint = Sprint.find(params[:id])
  	@backlog_item = BacklogItem.find(params[:id])
  	
  	@sprint.add(@backlog_item);
  	
  	
  end

end
