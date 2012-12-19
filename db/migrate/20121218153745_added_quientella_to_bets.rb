class AddedQuientellaToBets < ActiveRecord::Migration
  def self.up
    add_column :bets, :win_id, :integer
    add_column :bets, :place_id, :integer
    add_column :bets, :show_id, :integer
    add_column :bets, :fourth_id, :integer

  end

  def self.down
    remove_column :bets, :win_id
    remove_column :bets, :place_id
    remove_column :bets, :show_id
    remove_column :bets, :fourth_id
  end
end
