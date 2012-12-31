class AddedTransactionCodeToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :payment_servicer, :string
    add_column :transactions, :transaction_code, :string

  end

  def self.down
    remove_column :transactions, :payment_servicer
    remove_column :transactions, :transaction_code

  end
end
