class Makemodel < ActiveRecord::Base

  set_table_name "makemodel"

  def self.makes
    models = find(:all, :select => 'distinct make', :order => 'make ASC')
    cleanmakes = ["BRIGGS", 
                  "CUB CADET", 
                  "ECHO", 
                  "GENERAC", 
                  "HYDROGEAR", 
                  "KOHLER", 
                  "MTD", 
                  "N2", 
                  "OREGON", 
                  "TECUMSEH", 
                  "TROY-BILT", 
                  "WALBRO", 
                  "ZAMA"]
    models.each {|model| cleanmakes << model.make.upcase}
    return cleanmakes.compact.uniq
  end

end
