class BacklogMembersController < ApplicationController
	before_filter :authenticate, :only => [:show]

	def show			
		@backlog = Backlog.find(params[:id])		
		if cannot? :read, @backlog
  		deny_access
  	end
		@backlog_members = @backlog.collaborators		
	end
end
