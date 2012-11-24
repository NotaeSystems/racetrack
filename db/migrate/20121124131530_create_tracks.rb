class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.integer :owner_id
      t.boolean :public
      t.boolean :open
      t.text :description

      t.timestamps
    end
  end
end
