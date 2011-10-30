class BacklogMembersController < ApplicationController
	before_filter :authenticate, :only => [:show]

	def show			
		@backlog = Backlog.find(params[:id])		
		if cannot? :read, @backlog
  		deny_access
  	end
		@backlog_members = @backlog.collaborators		
	end
	
	def add
		@backlog = Backlog.find(params[:id])		

		if cannot? :create_items_in, @backlog
  		deny_access
  		return
  	end

		@email = params[:email]	
		@user = User.where(:email => @email).first
	
		if @user.nil?
			flash[:error] = "User does not exist!"
      redirect_to :action => 'show', :id => @backlog.id
      return 
    end

    @collaborator = @backlog.collaborators.where(:user_id => @user).first

    if @collaborator.nil?
    	@collaborator = @backlog.collaborators.build({:role => "member"})
    	@collaborator.user = @user
    	if @collaborator.save
				flash[:success] = "Added member!"
			else
				flash[:error] = "Could not add member!"
			end
    end
    
    redirect_to :action => 'show', :id => @backlog.id
	end
end
