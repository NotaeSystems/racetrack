class RemovedOpenFromTracks < ActiveRecord::Migration
  def self.up
    remove_column :tracks, :open
    remove_column :meets, :open
    remove_column :cards, :open
    remove_column :races, :open
  end

  def self.down
    add_column :tracks, :open
    add_column :meets, :open
    add_column :cards, :open
    add_column :races, :open
  end
end
