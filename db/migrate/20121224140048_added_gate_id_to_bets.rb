class AddedGateIdToBets < ActiveRecord::Migration
  def self.up
    add_column :bets, :gate_id, :integer
  end

  def self.down
    remove_column :bets, :gate_id
  end
end
