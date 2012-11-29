class CreateTrackusers < ActiveRecord::Migration
  def change
    create_table :trackusers do |t|
      t.integer :track_id
      t.integer :user_id
      t.string :role
      t.boolean :allow_comments
      t.string :nickname

      t.timestamps
    end
  end
end
