class AddedMorningLineToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :morning_line, :text
  end

  def self.down
    remove_column :races, :morning_line
  end
end
