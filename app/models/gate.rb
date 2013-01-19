class Gate < ActiveRecord::Base
  belongs_to :race
  belongs_to :horse
  has_many :offers
  has_many :bets
  has_many :contracts
  attr_accessible :finish, :horse_id, :number, :race_id, :status

  def best_buy_offer
    @best_buy_offer = self.offers.where("offer_type = 'Buy' and status = 'Pending' and expires > ?", Time.now).order('price desc').first
    unless @best_buy_offer.blank?
      @best_buy_offer
    else
     nil
    end  
  end

  def best_sell_offer
    @best_sell_offer = self.offers.where("offer_type = 'Sell' and status = 'Pending' and expires > ? ", Time.now).order('price desc').first
    unless @best_sell_offer.blank?
      @best_sell_offer
    else
     nil
    end  
  end

  def settle_contracts(user)
   ## see if there are any open buy and sell contracts for this gate and user
   open_buy_contract = Contract.where("gate_id = ? and user_id = ? and contract_type = 'Owner' and status = 'Open'", self.id, user.id).first
   if open_buy_contract
     open_sell_contract = Contract.where("gate_id = ? and user_id = ? and contract_type = 'Seller' and status = 'Open'", self.id, user.id).first
     if open_sell_contract
       open_buy_contract.status = 'Closed'
       open_buy_contract.save
       open_sell_contract.status = 'Closed'
       open_sell_contract.save
       settle_contracts(user)
     end
   else
     return
   end
  end

  def back_odds(user)
     open_sell_contract = Contract.where("gate_id = ? and user_id != ? and contract_type = 'Sell' and status = 'Open'", self.id, user.id).first
  end

  def lay_odds(user)
   open_buy_contract = Contract.where("gate_id = ? and user_id != ? and contract_type = 'Buy' and status = 'Open'", self.id, user.id).first
   open_buy_contract.price
  end

  def back_available
   available = 1000
  end

  def lay_available
   available = 1000
  end

  def scratch

      self.bets.where(:status => 'Pending').each do |bet|
        Credit.create(:user_id => bet.user_id,
                           :meet_id => bet.meet_id,
                           :amount => bet.amount,
                           :description => "#{self.horse.name}--Scratched. Returned bet.",
                           :card_id => self.race.card_id,
                           :credit_type => "Scratched",
                           :track_id => self.track_id
                             ) 
       bet.status = 'Scratched'
       bet.amount = 0

       bet.save
       bet.user.update_ranking(self.race.card.meet.id, bet.amount)
     end
     self.status = 'Scratched'
     self.save
  end

  def total_bets(bet_type = nil)
    if bet_type
      self.bets.where(:bet_type => bet_type, :status => 'Pending').sum(:amount) 
    else
      self.bets.sum(:amount) 
    end 
  end


 # def odds
 #   return 0 if self.total_bets == 0
 #   floated_odds = self.race.total_bets.to_f / self.total_bets.to_f
 #   odds = (floated_odds * 20).round.to_f/20
 # end

  def odds(bet_type)
    return 0 if self.total_bets(bet_type) == 0
    floated_odds = self.race.total_bets(bet_type).to_f / self.total_bets(bet_type).to_f
    odds = (floated_odds * 20).round.to_f/20
  end



end
