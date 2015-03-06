class Aritem < ActiveRecord::Base

  set_table_name "acc_trans"
  #set_primary_keys :trans_id
  set_primary_key "id"
  
  attr_accessible :trans_id, 
                  :chart_id, 
                  :amount, 
                  :cleared, 
                  :fx_transaction, 
                  :memo, 
                  :transdate

  #belongs_to :ar, :foreign_key => "id"
  #has_one :invoice, :foreign_key => "id"
  
  def save(id)
    self.trans_id = id
    self.save!
  end

end
