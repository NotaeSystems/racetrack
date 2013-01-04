class AddedRedWhiteToRankings < ActiveRecord::Migration
  def self.up
    add_column :rankings, :level, :string
    add_column :rankings, :race_id, :integer
    add_column :rankings, :league_id, :integer
    add_column :races, :meet_id, :integer   
  end

  def self.down
    remove_column :rankings, :level
    remove_column :rankings, :race_id
    remove_column :rankings, :league_id
    remove_column :races, :meet_id
  end
end
