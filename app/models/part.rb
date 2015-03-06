class Part < ActiveRecord::Base

  set_sequence_name "id"
  set_primary_key "id"
  
  has_many :orderitems, :foreign_key => "parts_id"
  has_many :invoices, :foreign_key => "parts_id"
  
  validates_uniqueness_of :id
  
  after_initialize :set_next_val
  
  def set_next_val
    #puts "set next value"
    if !self.id
      self.id = Part.count_by_sql "select nextval('id')"
    end
  end
  
  def before_save
    if !self.inventory_accno_id
      self.inventory_accno_id = Chart.find_by_accno(ACCOUNTING["inventory"].to_s).id
    end
    if !self.income_accno_id
      self.income_accno_id = Chart.find_by_accno(ACCOUNTING["sales"].to_s).id
    end
    if !self.expense_accno_id
      self.expense_accno_id = Chart.find_by_accno(ACCOUNTING["cogs"].to_s).id
    end
    self.priceupdate = Date.today
  end

  def set_id(newval)
    self.id = newval
  end

  def set_partnumber(newval)
    self.partnumber = newval
  end

  def set_description(newval)
    self.description = newval
  end

  def set_lastcost(newval)
    self.lastcost = newval
  end
  
  def set_listprice(newval)
    self.listprice = newval
  end
  
  def set_sellprice(newval)
    self.sellprice = newval
  end  
  
  def set_notes(newval)
    self.notes = newval
  end
  
  def set_alternate(newval)
    self.alternate = newval
  end  
end
