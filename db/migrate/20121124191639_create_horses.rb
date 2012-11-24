class CreateHorses < ActiveRecord::Migration
  def change
    create_table :horses do |t|
      t.string :name
      t.integer :race_id
      t.text :description
      t.integer :finish

      t.timestamps
    end
  end
end
