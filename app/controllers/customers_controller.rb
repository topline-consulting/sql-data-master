class CustomersController < ApplicationController
  
  layout :set_layout
  
  #auto_complete_for :customer, :name
  
  def index
    #list
    #render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #:redirect_to => { :action => :list }
  
  def list
    #@customer_pages, @customers = paginate :customers, :per_page => 10
    @customers = Customer.find(:all)
  end
  
  def filtered_list
    @function = params['function']
    @customers = Customer.find(:all, :conditions => ["name ~* ?", params[:customer_name]])
    
    render :partial=>'customer_list', :layout=>false
  end
  
  def show
    @customer = Customer.find(params[:id])
    @equipment = @customer.equipment
  end
  
  def special_rate
    if params[:id]
      @customer = Customer.find(params[:id])
    end
  rescue
    redirect_to :action => 'list'  
  end
  
  def customer_finder
    @customers = Customer.find(:all, :conditions => ["name ~* ?", params[:customer_name]])
    
    render :partial=>'customer_list', :layout=>false
  end  
  
  def apply_special_rate
    if fc = Financecharge.find_by_customer_id(params[:financecharge][:customer_id])
      fc.percentage = params[:financecharge][:percentage]
      fc.save!
    else
      fc = Financecharge.new(params[:financecharge])
      fc.save!
    end
  rescue
    flash[:notice] = 'Problem creating special finance charge rate'
  end
  
  def finance_charges
    
  end
  
  def apply_finance_charges
  
  interest_account = Chart.find_by_description("Interest")
  ar_account       = Chart.find_by_description("Accounts Receivables")
  
  logger.info 'Interest Account: ' + interest_account.id.to_s
  logger.info 'AR Account: ' + ar_account.id.to_s

    @daysoverdue = params[:charges][:daysoverdue]
    @percent = params[:charges][:percent]
    
    overdue = Ar.get_overdue(@daysoverdue.to_i)
    
    logger.info 'Total Overdue: ' + overdue.count.to_s
    
    overdue.each {|ar|

      #next_id = Ar.find(:last).id + 1
    
      fcar = Ar.new
      #fcar.id = next_id
      fcar.id = ActiveRecord::Base.connection.execute("select nextval('id')").entries.first['nextval']
      fcar.transdate = Date.today
      fcar.duedate = Date.today + 30
      fcar.invnumber = "FC:" + ar.customer.name + ":" + fcar.transdate.to_s
      fcar.invoice = "f"
      fcar.terms = 0
      fcar.curr = "USD"
      fcar.department_id = 0
      fcar.customer_id = ar.customer_id
      #if ar.customer.financecharge
        #fcar.netamount = (ar.amount - ar.paid) * (ar.customer.financecharge.percentage.to_f / 100)
      #else
        fcar.netamount = (ar.amount - ar.paid) * (@percent.to_f / 100) 
        fcar.netamount = (fcar.netamount * 10**2).round.to_f / 10**2
      #end
      if fcar.netamount > 0
        fcar.amount = fcar.netamount
        fcar.paid = 0
        fcar.taxincluded = 'f'
        #fcar.employee_id = args[:employee]
        fcar.notes = "Interest Charges"
        fcar.save!
        logger.info 'AR id = ' + fcar.id.to_s
        
        ar1 =  Aritem.new( :trans_id => fcar.id,
                           :chart_id => interest_account.id, 
                           :amount => fcar.netamount,
                           :cleared => "f",
                           :fx_transaction => "f",
                           :memo => "Interest Charges as of " + Date.today.to_s,
                           :transdate => Date.today.to_s)
        ar1.save(fcar.id)    
        #ar1.trans_id = fcar.id
        #ar1.save(:validate => false)                  
                                   
        ar2 =  Aritem.new(:trans_id => fcar.id,
                                   :chart_id => ar_account.id, 
                                   :amount => (fcar.netamount * (-1)),
                                   :cleared => "f",
                                   :fx_transaction => "f",
                                   :transdate => Date.today.to_s)
        
        ar2.save(fcar.id)                
        #ar2.trans_id = fcar.id        
        #ar2.save(:validate => false)

#fcar.aritems << ar1
#fcar.aritems << ar2
#fcar.save!
      end
    }  
  end
  
end
