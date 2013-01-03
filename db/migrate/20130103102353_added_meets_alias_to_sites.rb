class AddedMeetsAliasToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :meet_alias, :string
    add_column :sites, :card_alias, :string
    add_column :sites, :race_alias, :string
    add_column :sites, :horse_alias, :string
  end

  def self.down
    remove_column :sites, :meet_alias
    remove_column :sites, :card_alias
    remove_column :sites, :race_alias
    remove_column :sites, :horse_alias
  end
end
