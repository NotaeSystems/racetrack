class Achievement < ActiveRecord::Base
  attr_accessible :description, :image_url, :name, :points, :position, :rule, :status, :title, :url
end
