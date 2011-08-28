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
  	
  	redirect_to @sprint
  end

end
