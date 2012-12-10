class CreatedAchievementusers < ActiveRecord::Migration
  def change
    create_table :achievementusers do |t|
      t.integer :achievement_id
      t.integer :track_id
      t.integer :trackuser_id
      t.integer :user_id    
      t.string :meet_id

      t.timestamps
    end
  end
end
