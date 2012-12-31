class AddedStripeconnectToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :stripeconnect, :string
    add_column :sites, :allow_stripe, :boolean
    add_column :sites, :allow_bank, :boolean
    add_column :sites, :initial_bank, :integer
    add_column :sites, :daily_login_bonus, :integer
  end

  def self.down
    remove_column :sites, :stripeconnect
    remove_column :sites, :allow_stripe
    remove_column :sites, :allow_bank
    remove_column :sites, :initial_bank
    remove_column :sites, :daily_login_bonus

  end
end
