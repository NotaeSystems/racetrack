class MaxTracksAddedToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :max_tracks, :integer
  end

  def self.down
    remove_column :sites, :max_tracks
  end
end
