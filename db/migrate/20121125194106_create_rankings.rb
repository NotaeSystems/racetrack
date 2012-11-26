class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :user_id
      t.integer :meet_id
      t.decimal :amount
      t.string :rank

      t.timestamps
    end
  end
end
