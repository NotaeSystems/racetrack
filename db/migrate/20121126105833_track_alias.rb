class TrackAlias < ActiveRecord::Migration
  def self.up
    add_column :tracks, :track_alias, :string
    add_column :tracks, :meet_alias, :string
    add_column :tracks, :card_alias, :string
    add_column :tracks, :race_alias, :string
    add_column :tracks, :horse_alias, :string
  end

  def self.down
    remove_column :tracks, :track_alias
    remove_column :tracks, :meet_alias
    remove_column :tracks, :card_alias
    remove_column :tracks, :race_alias
    remove_column :tracks, :horse_alias
  end
end
