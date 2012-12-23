class AddedCardIdToHorses < ActiveRecord::Migration
  def self.up
    add_column :horses, :card_id, :integer
  end

  def self.down
    remove_column :horses, :card_id
  end
end
