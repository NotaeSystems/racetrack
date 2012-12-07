class AddedMemberAliasToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :credit_alias, :string
    add_column :tracks, :member_alias, :string
  end

  def self.down
    remove_column :tracks, :credit_alias
    remove_column :member, :credit_alias
  end
end
