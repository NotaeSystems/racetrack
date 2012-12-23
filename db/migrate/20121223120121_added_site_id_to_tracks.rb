class AddedSiteIdToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :site_id, :integer
    add_column :meets, :site_id, :integer
    add_column :cards, :site_id, :integer
    add_column :races, :site_id, :integer
    add_column :horses, :site_id, :integer
    add_column :credits, :site_id, :integer
     add_column :bets, :site_id, :integer
    add_column :leagues, :site_id, :integer
    add_column :rankings, :site_id, :integer
    add_column :authentications, :site_id, :integer
    add_column :users, :site_id, :integer
  end

  def self.down
    remove_column :tracks, :site_id
    remove_column :meets, :site_id
    remove_column :cards, :site_id
    remove_column :races, :site_id
    remove_column :horses, :site_id
    remove_column :credits, :site_id
    remove_column :bets, :site_id
    remove_column :leagues, :site_id
    remove_column :rankings, :site_id
    remove_column :authentications, :site_id
    remove_column :users, :site_id
  end

end
