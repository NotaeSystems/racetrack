class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :user_id
      t.integer :meet_id
      t.integer :amount
      t.text :description
      t.string :credit_type

      t.timestamps
    end
  end
end
