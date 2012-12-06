class Horse < ActiveRecord::Base
  belongs_to :race
  has_many :bets, :dependent => :destroy
  attr_accessible :description, :finish, :name, :race_id, :status, :track_id

  def total_bets
    self.bets.sum(:amount)  
  end
 
  
  def odds
    return 0 if self.total_bets == 0
    floated_odds = self.race.total_bets.to_f / self.total_bets.to_f
    odds = (floated_odds * 20).round.to_f/20
  end

  def scratch

      self.bets.where(:status => 'Open').each do |bet|
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
