class AddedCardIdToBets < ActiveRecord::Migration
  def self.up
    add_column :bets, :card_id, :integer
  end

  def self.down
    remove_column :bets, :card_id
  end
end
