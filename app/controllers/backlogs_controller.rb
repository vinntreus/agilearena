class BacklogsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	
	def create
		@backlog  = current_user.backlogs.build(params[:backlog])
    if @backlog.save
      flash[:success] = "Backlog created!"
      redirect_to @backlog
    else
      flash[:error] = "Could not create backlog!"
      redirect_to root_path
    end
	end
	
	def show
  	@backlog = Backlog.find(params[:id])
  	if cannot? :read, @backlog
  		deny_access
  	end
  	@backlog_item = BacklogItem.new
  	@backlog_items = @backlog.backlog_items.paginate :page => params[:page]	, :per_page => 50
  	@title = @backlog.title
  end
	
	def destroy
	  @backlog = Backlog.find(params[:id])
    authorize! :destroy, @backlog, :message => "Not allowed to delete backlog"		
		Backlog.delete(params[:id])
		
		redirect_to root_path
	end
	
end
