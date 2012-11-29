class CreateMeetleagues < ActiveRecord::Migration
  def change
    create_table :meetleagues do |t|
      t.integer :meet_id
      t.integer :league_id

      t.timestamps
    end
  end
end
