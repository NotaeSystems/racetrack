class CreateGates < ActiveRecord::Migration
  def change
    create_table :gates do |t|
      t.integer :number
      t.integer :horse_id
      t.integer :finish
      t.string :status
      t.integer :race_id

      t.timestamps
    end
  end
end
