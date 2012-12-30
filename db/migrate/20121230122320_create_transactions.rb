class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :name
      t.integer :amount
      t.text :description
      t.integer :user_id
      t.integer :site_id
      t.string :transaction_type
      t.integer :track_id

      t.timestamps
    end
  end
end
