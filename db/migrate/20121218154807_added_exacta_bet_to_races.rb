class AddedExactaBetToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :exacta, :boolean

  end

  def self.down
    remove_column :races, :exacta
  end
end
