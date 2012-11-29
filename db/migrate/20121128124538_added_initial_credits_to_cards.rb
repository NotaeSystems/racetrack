class AddedInitialCreditsToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :initial_credits, :integer
  end

  def self.down
    remove_column :cards, :initial_credits
  end
end
