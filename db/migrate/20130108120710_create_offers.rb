class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :user_id
      t.string :market
      t.integer :price
      t.integer :gate_id
      t.datetime :expires
      t.string :offer_type
      t.integer :number
      t.string :status

      t.timestamps
    end
  end
end
