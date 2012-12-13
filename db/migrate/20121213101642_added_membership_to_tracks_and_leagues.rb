class AddedMembershipToTracksAndLeagues < ActiveRecord::Migration
  def self.up
    add_column :tracks, :membership, :string
    add_column :leagues, :membership, :string
  end

  def self.down
    remove_column :tracks, :membership
    remove_column :leagues, :membership
  end
end
