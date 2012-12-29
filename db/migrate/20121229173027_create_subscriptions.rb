class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.string :email
      t.integer :user_id
      t.integer :site_id
      t.string :status
      t.integer :plan_id
      t.text :description
      t.string :stripe_customer_token
      t.datetime :begin_date
      t.datetime :expires
      t.integer :amount
      t.string :period

      t.timestamps
    end
  end
end
