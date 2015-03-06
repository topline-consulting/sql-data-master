class Order < ActiveRecord::Base

  set_table_name :oe
  
  belongs_to :customer
  has_many :orderitems, :foreign_key => "trans_id"

end
