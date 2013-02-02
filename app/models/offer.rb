class Offer < ActiveRecord::Base
  belongs_to :gate
  belongs_to :user
  belongs_to :race
  belongs_to :card
  belongs_to :meet
  belongs_to :track
  after_save :update_gate
  after_destroy :destroy_offer
  attr_accessor :from_now
  attr_accessible :expires, :gate_id, :market, :number, :offer_type, :price, :user_id, :from_now, :site_id, :track_id, 
                  :meet_id, :card_id, :race_id, :level

  validates_presence_of :price, :offer_type
  validates :price, :numericality => { :greater_than => 0, :less_than => 100 }


  def destroy_offer

    RacesPusher.new(self.gate.race).update_gates(self.gate.race).push
    OffersPusher.new(self).update_offers(self).push

    if self.offer_type == 'Buy' 
      if self.gate.best_buy_offer
        if self.price == self.gate.best_buy_offer.price
          RacesPusher.new(self.gate.race).flash_gate(gate.best_buy_offer, self).push
        end
      end
    elsif self.offer_type == 'Sell'
       if self.gate.best_sell_offer  
         if self.price == self.gate.best_sell_offer.price
           RacesPusher.new(self.gate.race).flash_gate(gate.best_sell_offer, self).push
         end
       end
    end
  end
 

  def update_gate
   if self.status == 'Cancelled' || self.status == 'Completed'
     RacesPusher.new(self.gate.race).flash_gate(self.gate, self).push
     OffersPusher.new(self).update_offers(self).push
   else
     # RacesPusher.new(self.gate.race).update_gates(self.gate.race).push
      OffersPusher.new(self).update_offers(self).push
      ### not working if update_gates runs above
      if self.offer_type == 'Buy' 
        if self.gate.best_buy_offer
          if self.price == self.gate.best_buy_offer.price
            RacesPusher.new(self.gate.race).flash_gate(self.gate, self).push
          end
        end
      elsif self.offer_type == 'Sell'
         if self.gate.best_sell_offer  
           if self.price == self.gate.best_sell_offer.price
             RacesPusher.new(self.gate.race).flash_gate(self.gate, self).push
           end
         end
      end
    end
  end
 
end
