class BacklogItemsController < ApplicationController
  include ActionView::Helpers::DateHelper
  
  before_filter :authenticate, :only => [:create, :destroy, :update, :sort]
  respond_to :html, :json
  
  def show
    @backlog_item = BacklogItem.find(params[:id])
    authorize! :read, @backlog_item, :message => "Not allowed to see backlogitem"
  end
  
  def edit
    @backlog_item = BacklogItem.find(params[:id])
    authorize! :update, @backlog_item, :message => "Not allowed to update backlogitem"
  end
  
  def create
    @backlog = Backlog.find(params[:backlog_id])		
    @backlog_item = @backlog.backlog_items.build(params[:backlog_item])
    authorize! :create, @backlog_item, :message => "Not allowed to create backlogitem"
    
    if @backlog_item.save
      render :json => { :id => @backlog_item.id, 
                        :title => @backlog_item.title,
                        :points => @backlog_item.points,
												:status => @backlog_item.status.downcase }	
    else
      render :text => "Could not create backlogitem", :status => 500
    end 
    
  end	
  
  def update
    @backlog_item = BacklogItem.find(params[:id])
    authorize! :update, @backlog_item, :message => "Not allowed to update backlogitem"
    
    if @backlog_item.update_attributes(params[:backlog_item])
      respond_with(@backlog_item)
    else
      render :text => "Could not update backlogitem", :status => 500
    end
  end
  
  def destroy
    @backlog_item = BacklogItem.find(params[:id])		
    authorize! :destroy, @backlog_item, :message => "Not allowed to delete backlogitem"		
    BacklogItem.delete(params[:id])
    
    render :json => {}
  end
  
  def sort
    @backlog_item = BacklogItem.find(params[:id])		
    authorize! :sort, @backlog_item, :message => "Not allowed to sort backlogitem"		
    
    Backlog.sort_items(@backlog_item, params[:new_parent].to_i)		
    
    render :json => {}
  end
end
