class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :user_id
      t.integer :horse_id
      t.integer :amount
      t.string :bet_type
      t.integer :meet_id

      t.timestamps
    end
  end
end
