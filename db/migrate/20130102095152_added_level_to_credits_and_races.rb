class AddedLevelToCreditsAndRaces < ActiveRecord::Migration
  def self.up
    add_column :sites, :level, :string
    add_column :tracks, :level, :string
    add_column :meets, :level, :string
    add_column :cards, :level, :string
    add_column :races, :level, :string
    add_column :bets, :level, :string
    add_column :credits, :level, :string
    add_column :credits, :race_id, :integer
    add_column :transactions, :level, :string
  end

  def self.down
    remove_column :sites, :level
    remove_column :tracks, :level
    remove_column :meets, :level
    remove_column :cards, :level
    remove_column :races, :level
    remove_column :bets, :level
    remove_column :credits, :level


    remove_column :credits, :race_id
    remove_column :transactions, :level
  end
end
