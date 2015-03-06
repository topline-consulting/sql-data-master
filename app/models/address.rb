class Address < ActiveRecord::Base

  set_table_name 'address'
  
  belongs_to :customer, :foreign_key => 'trans_id'

end