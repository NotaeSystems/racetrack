class AddedTrackIdToCredits < ActiveRecord::Migration
  def self.up
    add_column :credits, :track_id, :integer
  end

  def self.down
    remove_column :credits, :track_id
  end
end
