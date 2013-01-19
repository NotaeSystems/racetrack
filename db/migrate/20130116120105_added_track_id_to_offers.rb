class AddedTrackIdToOffers < ActiveRecord::Migration
  def self.up
    add_column :contracts, :card_id, :integer
    add_column :contracts, :track_id, :integer
    add_column :contracts, :meet_id, :integer

    add_column :offers, :race_id, :integer
    add_column :offers, :card_id, :integer
    add_column :offers, :meet_id, :integer
    add_column :offers, :track_id, :integer
    add_column :offers, :site_id, :integer
  end

  def self.down
    remove_column :horses, :card_id
  end
end
