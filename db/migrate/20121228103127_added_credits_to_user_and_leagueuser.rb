class AddedCreditsToUserAndLeagueuser < ActiveRecord::Migration
  def self.up
    add_column :users, :amount, :integer
    add_column :leagueusers, :amount, :integer
  end

  def self.down
    remove_column :users, :amount
    remove_column :leagueusers, :amount
  end
end
