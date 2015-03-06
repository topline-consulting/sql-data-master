class Orderitem < ActiveRecord::Base
  
  belongs_to :order, :foreign_key => "trans_id"
  belongs_to :part, :foreign_key => "parts_id"

end