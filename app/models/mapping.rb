class Mapping < ActiveRecord::Base

  has_many :mapcolumns

  def before_save
    self.version += 1
  end

end
