class Page < ActiveRecord::Base
  attr_accessible :body, :name, :permalink, :site_id

  validates_uniqueness_of :permalink
  
  def to_param
    permalink
  end

end
