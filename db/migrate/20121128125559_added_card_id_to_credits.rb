class AddedCardIdToCredits < ActiveRecord::Migration
  def self.up
    add_column :credits, :card_id, :integer
  end

  def self.down
    remove_column :credits, :card_id
  end
end
