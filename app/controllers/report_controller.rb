class ReportController < ApplicationController

  layout :set_layout
  
  def index
  
  end
  
  def salestax
  
  end
  
  def calculate_salestax

# Build dates
    enddate = params[:report][:enddate].to_date
    startdate = Date.new(enddate.year, enddate.month, 1)
    
# Reset total values    
    @total_sales = 0
    @total_tax = 0
    @total_taxable_sales = 0
    @total_nontaxable_sales = 0
    
# Calculate sales tax values    
    for ar in Ar.find(:all, :conditions => ['transdate >= ? and transdate <= ?', startdate, enddate])
      @total_sales += ar.amount
      ar.invoices.each {|invoice|
      
        
      
        @total_tax += invoice.qty * invoice.sellprice * 0.05
      }
    end
    
    render :partial=>'salestax_details', :layout=>false
  rescue
    render :partial=>'salestax_details', :layout=>false
  end

end