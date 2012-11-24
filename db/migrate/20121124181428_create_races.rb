class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.integer :card_id
      t.boolean :open
      t.datetime :start_betting_time
      t.datetime :post_time
      t.text :description
      t.boolean :completed
      t.datetime :completed_date

      t.timestamps
    end
  end
end
