class ConfigsForSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :allow_facebook, :boolean
    add_column :sites, :allow_twitter, :boolean
    add_column :sites, :allow_leagues, :boolean
  end

  def self.down
    remove_column :sites, :allow_facebook
    remove_column :sites, :allow_twitter
    remove_column :sites, :allow_leagues
  end
end
