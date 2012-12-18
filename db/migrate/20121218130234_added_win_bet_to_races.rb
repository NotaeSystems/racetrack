class AddedWinBetToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :win, :boolean
    add_column :races, :place, :boolean
    add_column :races, :show, :boolean
    add_column :races, :quintella, :boolean
    add_column :races, :trifecta, :boolean
  end

  def self.down
    remove_column :races, :win
    remove_column :races, :place
    remove_column :races, :show
    remove_column :races, :quintella
    remove_column :races, :trifecta
  end
end
