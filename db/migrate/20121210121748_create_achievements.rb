class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :name
      t.string :title
      t.string :url
      t.text :description
      t.string :image_url
      t.integer :points
      t.text :rule
      t.integer :position
      t.string :status

      t.timestamps
    end
  end
end
