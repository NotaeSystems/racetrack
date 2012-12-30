class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :site_id
      t.text :description
      t.integer :amount
      t.string :period
      t.string :title
      t.string :plan_type
      t.integer :max_tracks
      t.integer :max_members
      t.timestamps
    end
  end
end
