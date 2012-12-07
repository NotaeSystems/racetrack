class AddedStatusToTrackUsers < ActiveRecord::Migration
  def self.up
    add_column :trackusers, :status, :string
  end

  def self.down
    remove_column :trackusers, :status
  end
end
