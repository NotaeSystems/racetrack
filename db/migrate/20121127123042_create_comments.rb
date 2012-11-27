class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :meet_id
      t.integer :race_id
      t.integer :card_id
      t.integer :track_id
      t.text :body

      t.timestamps
    end
  end
end
