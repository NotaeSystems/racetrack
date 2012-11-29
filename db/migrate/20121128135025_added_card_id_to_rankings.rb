class AddedCardIdToRankings < ActiveRecord::Migration
  def self.up
    add_column :rankings, :card_id, :integer
  end

  def self.down
    remove_column :rankings, :card_id
  end
end
