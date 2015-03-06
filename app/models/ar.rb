class Ar < ActiveRecord::Base

  set_table_name "ar"
  set_primary_key "id"
  set_sequence_name "id"
  
  belongs_to :customer
  #has_many :aritems, :foreign_key => "trans_id"
  #accepts_nested_attributes_for :aritems
  #has_many :invoices, :foreign_key => 'trans_id'
  
  def self.get_overdue(days)
  
    overduedate = Date.today - days
    
    return find_by_sql("select customer_id, sum(paid) as paid, sum(amount) as amount from ar where duedate < '" + overduedate.to_s + "' and paid <> amount group by customer_id order by customer_id asc;")
  
  end

end
