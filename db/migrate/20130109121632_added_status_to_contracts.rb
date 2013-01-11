class AddedStatusToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :status, :string
    add_column :contracts, :price, :integer
   end

  def self.down
    remove_column :contracts, :status
    remove_column :contracts, :price
  end
end
