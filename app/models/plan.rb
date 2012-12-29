class Plan < ActiveRecord::Base
  attr_accessible :amount, :description, :name, :period, :site_id
end
