class AddedRaceIdToBets < ActiveRecord::Migration
  def self.up
    add_column :bets, :race_id, :integer
  end

  def self.down
    remove_column :bets, :race_id
  end
end
