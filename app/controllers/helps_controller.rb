class HelpsController < ApplicationController

  layout 'sql'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def list
    @helps = Help.find(:all)
  end

  def show
    @help = Help.find(params[:id])
  end

  def new
    @help = Help.new
  end

  def create
    @help = Help.new(params[:help])
    if @help.save
      flash[:notice] = 'Help was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @help = Help.find(params[:id])
  end

  def update
    @help = Help.find(params[:id])
    if @help.update_attributes(params[:help])
      flash[:notice] = 'Help was successfully updated.'
      redirect_to :action => 'show', :id => @help
    else
      render :action => 'edit'
    end
  end

  def destroy
    Help.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
