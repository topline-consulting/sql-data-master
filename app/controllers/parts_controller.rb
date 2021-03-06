class PartsController < ApplicationController

  layout 'sql'

  def index
    #list
    #render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def list
    @parts = Part.find(:all)
  end

  def show
    @part = Part.find(params[:id])
  end

  def price_update
    @makes = Makemodel.makes
  end
  
  def read_file
    @pricefile = request.raw_post
    render :partial => 'file_contents', :layout => false
  end
  
  def update_prices  
    logger.info "Price update start..."
    logger.info "File name: " + params[:pricefile].to_s
    logger.info "Manufacturer: " + params[:priceupdate][:manufacturer].to_s
    logger.info "Markup: " + params[:markup].to_s
    
    pricefile = Tempfile.new("pricefile") #File.open("./pricefile", "w")
    logger.info("TEMP FILE: " + pricefile.path.to_s)
    pricefile << params[:pricefile].read
    pricefile.close
# /home/nleach/.rvm/gems/ruby-1.9.2-p290@rails31/bin/rake    
    system "rake --trace price_update MANUFACTURER='#{params[:priceupdate][:manufacturer]}' PRICEFILE=#{pricefile.path.to_s} MARKUP=#{params[:markup]} &"
  end

  def job_status

  end

  def task_progress
    #@progress = MiddleMan.get_worker(session[:jobkey]).progress
    #if @progress
    #  session[:parts_job_status] = @progress[4]
    #  session[:parts_total_records] = @progress[0]
    #  session[:parts_total_created] = @progress[1]
    #  session[:parts_total_updated] = @progress[2]
    #  session[:parts_total_errors] = @progress[3]
    #end
    #render :layout => false
  #rescue
    #render :layout => false
  end
end
