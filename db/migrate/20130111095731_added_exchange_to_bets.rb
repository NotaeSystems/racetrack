class AddedExchangeToBets < ActiveRecord::Migration
  def self.up
    add_column :races, :exchange, :boolean
   end

  def self.down
    remove_column :races, :exchange
  end
end
