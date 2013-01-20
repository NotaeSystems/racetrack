class Offer < ActiveRecord::Base
  belongs_to :gate
  belongs_to :user
  belongs_to :race
  belongs_to :card
  belongs_to :meet
  belongs_to :track

  attr_accessor :from_now
  attr_accessible :expires, :gate_id, :market, :number, :offer_type, :price, :user_id, :from_now, :site_id, :track_id, 
                  :meet_id, :card_id, :race_id

  validates_presence_of :price, :offer_type
  validates :price, :numericality => { :greater_than => 0, :less_than => 100 }

 
end
