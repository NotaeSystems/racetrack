class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.integer :meet_id
      t.boolean :open
      t.text :description
      t.boolean :completed
      t.datetime :completed_date

      t.timestamps
    end
  end
end
