class AddedAliasToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :bet_alias, :string
    add_column :sites, :track_alias, :string
    add_column :sites, :member_alias, :string
    add_column :sites, :credit_alias, :string
    add_column :sites, :bank_alias, :string
    add_column :sites, :live_push, :boolean
  end

  def self.down
    remove_column :sites, :bet_alias
    remove_column :sites, :track_alias
    remove_column :sites, :member_alias
    remove_column :sites, :credit_alias
    remove_column :sites, :bank_alias
    remove_column :sites, :live_push
  end
end
