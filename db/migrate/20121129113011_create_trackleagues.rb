class CreateTrackleagues < ActiveRecord::Migration
  def change
    create_table :trackleagues do |t|
      t.integer :league_id
      t.integer :track_id

      t.timestamps
    end
  end
end
