class CreateLeagueusers < ActiveRecord::Migration
  def change
    create_table :leagueusers do |t|
      t.integer :user_id
      t.integer :league_id
      t.string :status
      t.string :nickname
      t.boolean :active

      t.timestamps
    end
  end
end
