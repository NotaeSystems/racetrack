class Horse < ActiveRecord::Base
  belongs_to :race
  belongs_to :track
  belongs_to :card
  has_many :bets, :dependent => :destroy
  has_many :gates,  :dependent => :destroy

  attr_accessible :description, :finish, :name, :race_id, :status, :track_id, :card_id, :stable_id

  def total_bets(bet_type = nil)
    if bet_type
      self.bets.where(:bet_type => bet_type, :status => 'Pending').sum(:amount) 
    else
      self.bets.sum(:amount) 
    end 
  end
 

  def odds
    return 0 if self.total_bets == 0
    floated_odds = self.race.total_bets.to_f / self.total_bets.to_f
    odds = (floated_odds * 20).round.to_f/20
  end

  def odds(bet_type)
    return 0 if self.total_bets(bet_type) == 0
    floated_odds = self.race.total_bets(bet_type).to_f / self.total_bets.to_f
    odds = (floated_odds * 20).round.to_f/20
  end

  def scratch

      self.bets.where(:status => 'Pending').each do |bet|
        Credit.create(:user_id => bet.user_id,
                           :meet_id => bet.meet_id,
                           :amount => bet.amount,
                           :description => "#{self.name}--Scratched. Returned bet.",
                           :card_id => self.race.card_id,
                           :credit_type => "Scratched",
                           :track_id => self.track_id
                             ) 
       bet.status = 'Scratched'
       bet.amount = 0
       self.status = 'Scratched'
       self.save
       bet.save
           bet.user.update_ranking(self.race.card.meet.id, bet.amount)
     end
  end
end
