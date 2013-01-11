class Offer < ActiveRecord::Base
  belongs_to :gate
  belongs_to :user
  attr_accessor :from_now
  attr_accessible :expires, :gate_id, :market, :number, :offer_type, :price, :user_id, :from_now

  validates_presence_of :price, :offer_type
  validates :price, :numericality => { :greater_than => 0, :less_than => 100 }

 
end
