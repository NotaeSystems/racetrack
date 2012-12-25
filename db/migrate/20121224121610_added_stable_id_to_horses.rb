class AddedStableIdToHorses < ActiveRecord::Migration
  def self.up
    add_column :horses, :stable_id, :integer
  end

  def self.down
    remove_column :horses, :stable_id
  end
end
