class AddedInitialCreditsToMeets < ActiveRecord::Migration
  def self.up
    add_column :meets, :initial_credits, :integer
  end

  def self.down
    remove_column :meets, :initial_credits
  end
end
