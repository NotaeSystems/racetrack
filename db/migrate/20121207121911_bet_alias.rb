class BetAlias < ActiveRecord::Migration
  def self.up
    add_column :tracks, :bet_alias, :string
  end

  def self.down
    remove_column :tracks, :bet_alias
  end
end
