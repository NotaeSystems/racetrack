class CreateMeets < ActiveRecord::Migration
  def change
    create_table :meets do |t|
      t.string :name
      t.integer :track_id
      t.boolean :open
      t.text :description
      t.boolean :completed
      t.datetime :completed_date

      t.timestamps
    end
  end
end
