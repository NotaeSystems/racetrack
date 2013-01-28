class AddedLevelToOffersAndContracts < ActiveRecord::Migration
  def self.up
    add_column :offers, :level, :string
    add_column :contracts, :level, :string
  end

  def self.down
    remove_column :offers, :level
    remove_column :contracts, :level
  end
end
