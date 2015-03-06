class Invoice < ActiveRecord::Base

  set_table_name 'invoice'
  
  belongs_to :part, :foreign_key => 'parts_id'

end