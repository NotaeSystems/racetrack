class Page < ActiveRecord::Base
  attr_accessible :body, :name, :permalink, :site_id

  validates_presence_of :permalink, :name
  validates_uniqueness_of :permalink

  
  def to_param
    permalink
  end

end
