class Customer < ActiveRecord::Base
  
  set_table_name 'customer'
  
  has_many :ars
  has_many :orders
  has_many :addresses, :foreign_key => 'trans_id'
  #has_one :financecharge
  
  def equipment
    equipmentlist = []
    self.ars.each {|ar|
      ar.invoices.each {|inv|
        begin
          if inv.serialnumber > ''
            equipmentlist << [ar.invnumber, ar.transdate, inv.part.partnumber, inv.serialnumber, inv.description]
          end
        rescue
        end
      }
    }
    return equipmentlist
  rescue
    return nil
  end
  
end
