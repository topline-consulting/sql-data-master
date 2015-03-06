# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :access, :except => [:index, :login, :logout]

  def set_layout
    return 'sql'
  end

  def access
    #if session[:admin] != true
    #  flash[:notice] = 'You must log in to perform that action'
    #  redirect_to :controller => 'access', :action => 'index'
    #end
  end  
  
end
