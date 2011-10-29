class BacklogMembersController < ApplicationController
	before_filter :authenticate, :only => [:show]

	def show	
		@backlog = Backlog.find(params[:id])		
		@backlog_members = @backlog.collaborators		
	end
end
