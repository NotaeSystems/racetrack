class AddedStatus < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :string
    add_column :tracks, :status, :string
    add_column :races, :status, :string
    add_column :meets, :status, :string
    add_column :horses, :status, :string
    add_column :credits, :status, :string
    add_column :cards, :status, :string
    add_column :bets, :status, :string
  end

  def self.down
    remove_column :users, :string
    remove_column :tracks, :string
    remove_column :races, :string
    remove_column :meets, :string
    remove_column :horses, :string
    remove_column :credits, :string
    remove_column :cards, :string
    remove_column :bets, :string
  end
end
