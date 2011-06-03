class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  rescue_from CanCan::AccessDenied do |exception|
    render :text => exception.message, :status => 403
  end

end
