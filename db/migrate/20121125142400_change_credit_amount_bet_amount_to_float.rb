class ChangeCreditAmountBetAmountToFloat < ActiveRecord::Migration
  def up
    change_table :credits do |t|
      t.change :amount, :decimal
    end
    change_table :bets do |t|
      t.change :amount, :decimal
    end

  end

  def down
    change_table :credits do |t|
      t.change :amount, :integer
    end
    change_table :bets do |t|
      t.change :amount, :integer
    end


  end
end
