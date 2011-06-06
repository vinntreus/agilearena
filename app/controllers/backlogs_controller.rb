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
  	if @backlog.can_show_to(current_user) == false
  		redirect_to signin_path
  	end
  	@backlog_item = BacklogItem.new
  	@backlog_items = @backlog.backlog_items.paginate(:page => params[:page])
  	@title = @backlog.title
  end
	
	def destroy
	  @backlog = Backlog.find(params[:id])
    authorize! :destroy, @backlog, :message => "Not allowed to delete backlog"		
		Backlog.delete(params[:id])
		
		#Redirection to proper url TODO!
	  render :json => {}
	end
	
end
