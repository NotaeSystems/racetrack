class AddedResultsToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :results, :text
  end

  def self.down
    remove_column :races, :results
  end
end
