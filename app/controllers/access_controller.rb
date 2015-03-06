class AccessController < ApplicationController

  layout :set_layout

  def index
    
  end

  def login
    #if params[:admin]
    #  if params[:admin][:password] == Configuration.find_by_name('admin_password').value
        session[:admin] = true
    #    flash[:notice] = 'Admin password correct'
    #  else
    #    session[:admin] = nil
    #    flash[:notice] = 'Admin password incorrect...please try again'
    #  end
    #end
    redirect_to :controller => 'welcome'
  #rescue
  #  redirect_to :action => 'index'
  end

  def logout
    session[:admin] = nil
    redirect_to :action => 'index'
  end
end
