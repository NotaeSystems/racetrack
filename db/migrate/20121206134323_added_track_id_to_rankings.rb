class AddedTrackIdToRankings < ActiveRecord::Migration
  def self.up
    add_column :rankings, :track_id, :integer
    add_column :bets, :track_id, :integer
    add_column :cards, :track_id, :integer
    add_column :horses, :track_id, :integer
    add_column :races, :track_id, :integer


  end

  def self.down
    remove_column :rankings, :track_id
    remove_column :bets, :track_id
    remove_column :cards, :track_id
    remove_column :horses, :track_id
    remove_column :races, :track_id
  end
end
