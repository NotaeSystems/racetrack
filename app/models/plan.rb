class Plan < ActiveRecord::Base
  attr_accessible :amount, :description, :name, :period, :site_id, :title, :max_members, :max_tracks
end
