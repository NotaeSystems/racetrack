class AddedLayBetToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :lay, :boolean
    add_column :races, :back, :boolean
    add_column :bets, :odds, :decimal
    add_column :bets, :expires, :datetime
   end

  def self.down
    remove_column :races, :lay
    remove_column :races, :back
    remove_column :bets, :odds
    remove_column :bets, :expires
  end
end
