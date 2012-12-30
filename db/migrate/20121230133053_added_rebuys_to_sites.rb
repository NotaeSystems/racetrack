class AddedRebuysToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :rebuy_credits, :integer
    add_column :sites, :rebuy_charge, :integer
    add_column :sites, :allow_rebuys, :boolean
  end

  def self.down
    remove_column :sites, :rebuy_credits
    remove_column :sites, :rebuy_charge
    remove_column :sites, :allow_rebuys
  end
end
