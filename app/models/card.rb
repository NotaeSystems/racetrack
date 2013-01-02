class Card < ActiveRecord::Base
  has_many :races, :dependent => :destroy
  belongs_to :meet
  has_many :comments, :dependent => :destroy
  has_many :credits, :dependent => :destroy
  has_many :rankings, :dependent => :destroy
  attr_accessible :completed, :completed_date, :description, :level, :meet_id, :name, :open, :status, :initial_credits, :track_id

  def refresh_credits(user, credit_type, amount)
   
   Credit.create( :user_id => user.id,
                   :amount => amount,
                   :credit_type => credit_type,
                   :card_id => self.id,
                   :meet_id => self.meet_id,
                   :description => 'Refreshed credits',
                   :track_id => self.meet.track.id
                 )
   user.update_card_ranking(self, amount)

  end

  def close
    ## calculate total credits of all users that bet on card
    total_rebuy_credits = self.credits.where("credit_type IN ('Rebuy','Initial', 'Borrowed')").sum(:amount)
    logger.debug  "total rebuy_credits = #{total_rebuy_credits}"
    number_of_card_bettors = self.credits.where("credit_type IN ('Initial', 'Borrowed')").count
    logger.debug "total number bettors = #{number_of_card_bettors}"
    ## find all users that bet in the card
    credits = self.credits.where("credit_type IN ('Initial', 'Borrowed')")
    credits.each do  |credit|
      user = credit.user
      logger.info "User is #{user.name}"
      total_user_credits = user.credits.where("card_id = ?", self.id).sum(:amount)
      logger.info "total user credits is #{total_user_credits}"
      ##TO bettor repays borrowed credits
      borrowed_credits = self.credits.where("credit_type IN ('Rebuy','Initial', 'Borrowed')")
      borrowed_credits.each do |borrowed|
        Credit.create( :user_id => borrowed.user_id,
                   :amount => -borrowed.amount,
                   :credit_type => 'Paid Back',
                   :card_id => borrowed.card_id,
                   :meet_id => borrowed.meet_id,
                   :track_id => borrowed.track_id,
                   :description => "Paid back #{borrowed.credit_type} credits. Credit id: #{borrowed.id}",
                   :track_id => borrowed.track_id
                 )
      end
      ## create ranking record for card
     # Ranking.create( :user_id => user.id,
     #                 :card_id => self.id,
     #                 :weight => 1, 
     #                 :amount => total_user_credits
     #                 ) 
      ##
    end
    ### now calculate the percentile and add to ranking record
   # rankings = Ranking.pluck('amount').where("card_id = ?", self.id)
   # percentile95 = rankings.percentile(95)
   # percentile90 = rankings.percentile(90)
   # Ranking.where("card_id = ? and amount > ?",self.id, percentile95-1).update_all(:percentile => 95)
   # Ranking.where("card_id = ? and amount > ?",self.id, percentile95-1).update_all(:percentile => 95
    ### percentile is number_of_users /  rank
      ## as to each user
        ## calcuate total credits of user
        ## as to each user find order of finish

        ## determine percentile points
        ## multiply percential points by card weight
        ## add card weight to user's ranking
        ## add percentile points to user's ranking
        ## mark card as closed
   self.status = 'Closed'
   self.save
  end
end
