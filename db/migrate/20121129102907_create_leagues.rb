class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.text :description
      t.string :status
      t.integer :owner_id
      t.boolean :active

      t.timestamps
    end
  end
end
