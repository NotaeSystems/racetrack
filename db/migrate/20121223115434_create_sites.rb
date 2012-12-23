class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.text :description
      t.integer :owner_id
      t.integer :initial_credits
      t.string :facebook_key
      t.string :facebook_secret
      t.string :twitter_key
      t.string :twitter_secret
      t.string :domain
      t.string :slug
      t.string :status
      t.string :sanctioned

      t.timestamps
    end
  end
end
