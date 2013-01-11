class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :contract_type
      t.integer :user_id
      t.integer :site_id
      t.integer :gate_id
      t.integer :race_id
      t.integer :number

      t.timestamps
    end
  end
end
