class AddedRaceInitialCredits < ActiveRecord::Migration
  def self.up
    add_column :races, :initial_credits, :integer

  end

  def self.down
    remove_column :races, :initial_credits
  end
end
