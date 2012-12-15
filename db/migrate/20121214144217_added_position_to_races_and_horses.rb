class AddedPositionToRacesAndHorses < ActiveRecord::Migration
  def self.up
    add_column :races, :position, :integer
    add_column :horses, :position, :integer
  end

  def self.down
    remove_column :races, :position
    remove_column :horses, :position
  end
end
