class SprintsController < ApplicationController

	def show
		@sprint = Sprint.find(params[:id])
		
	end

  def create
  	@backlog = Backlog.find(params[:backlog_id])
		@sprint =	@backlog.sprints.create!
  	
  	redirect_to @sprint
  end

end
