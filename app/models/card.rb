class Card < ActiveRecord::Base
  has_many :races
  belongs_to :meet
  has_many :comments
  has_many :credits
  has_many :rankings
  attr_accessible :completed, :completed_date, :description, :meet_id, :name, :open, :status, :initial_credits

  def refresh_credits(user, credit_type, amount)
   
   Credit.create( :user_id => user.id,
                   :meet_id => self.id,
                   :amount => amount,
                   :credit_type => credit_type,
                   :card_id => self.id,
                   :description => 'Refreshed credits'
                 )
   user.update_card_ranking(self, amount)

  end

  def close
    ## calculate total credits of all users that bet on card
    total_rebuy_credits = self.credits.where("credit_type IN ('Rebuy','Initial')").sum(:amount)
    logger.debug  "total rebuy_credits = #{total_rebuy_credits}"
    number_of_card_bettors = self.credits.where("credit_type IN ('Initial')").count
    logger.debug "total number bettors = #{number_of_card_bettors}"
    ## find all users that bet in the card
    credits = self.credits.where("credit_type IN ('Initial')")
    credits.each do  |credit|
      user = credit.user
      logger.info "User is #{user.name}"
      total_user_credits = user.credits.where("card_id = ?", self.id).sum(:amount)
      logger.info "total user credits is #{total_user_credits}"
      ## create ranking record for card

      ##
    end
      ## as to each user
        ## calcuate total credits of user
        ## as to each user find order of finish

        ## determine percentile points
        ## multiply percential points by card weight
        ## add card weight to user's ranking
        ## add percentile points to user's ranking
        ## mark card as closed
  end
end
