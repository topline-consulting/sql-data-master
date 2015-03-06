class MapcolumnsController < ApplicationController

  layout :set_layout

  # GET /mapcolumns
  # GET /mapcolumns.xml
  def index
    @mapcolumns = Mapcolumn.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mapcolumns }
    end
  end

  # GET /mapcolumns/1
  # GET /mapcolumns/1.xml
  def show
    @mapcolumn = Mapcolumn.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mapcolumn }
    end
  end

  # GET /mapcolumns/new
  # GET /mapcolumns/new.xml
  def new
    @mapcolumn = Mapcolumn.new
    @partcolumns = Part.column_names
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mapcolumn }
    end
  end

  # GET /mapcolumns/1/edit
  def edit
    @mapcolumn = Mapcolumn.find(params[:id])
  end

  # POST /mapcolumns
  # POST /mapcolumns.xml
  def create
    #@mapping = Mapping.find(params[:mapping_id])
    @mapcolumn = Mapcolumn.new(params[:mapcolumn])

    respond_to do |format|
      if @mapcolumn.save
        flash[:notice] = 'Mapcolumn was successfully created.'
        format.html { redirect_to(mapping_path(@mapcolumn.mapping_id)) }
        format.xml  { render :xml => @mapcolumn, :status => :created, :location => @mapcolumn }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mapcolumn.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mapcolumns/1
  # PUT /mapcolumns/1.xml
  def update
    @mapcolumn = Mapcolumn.find(params[:id])

    respond_to do |format|
      if @mapcolumn.update_attributes(params[:mapcolumn])
        flash[:notice] = 'Mapcolumn was successfully updated.'
        format.html { redirect_to(@mapcolumn) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mapcolumn.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mapcolumns/1
  # DELETE /mapcolumns/1.xml
  def destroy
    @mapcolumn = Mapcolumn.find(params[:id])
    mapping = @mapcolumn.mapping_id.to_i
    @mapcolumn.destroy

    respond_to do |format|
      format.html { redirect_to(mapping_path(mapping)) }
      format.xml  { head :ok }
    end
  end
end
