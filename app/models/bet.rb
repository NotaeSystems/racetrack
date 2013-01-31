class Bet < ActiveRecord::Base
  #scope :win
  belongs_to :user
  belongs_to :horse
  belongs_to :meet
  belongs_to :card
  belongs_to :track
  belongs_to :race
  belongs_to :gate
  
  belongs_to :win, :class_name => "Horse"
  belongs_to :place, :class_name => "Horse"
  belongs_to :show, :class_name => "Horse"
  belongs_to :fourth, :class_name => "Horse"

  attr_accessible :amount,:bet_type, :horse_id, :meet_id, :user_id, :race_id, :status, :track_id, 
                   :win_id, :place_id, :show_id, :fourth_id, :card_id, :gate_id, :level, :back_odds, :odds, :expires
  validates_presence_of :amount, :bet_type

  after_save :update_race

  def update_race
    #RacesPusher.new(self.race).update_gates(self.race).push
    RacesPusher.new(self.race).update_odds(self.gate).push
    check_for_card_bonus
    check_for_race_bonus
  end

  def check_for_card_bonus
    ## see if bettor has been given initial card credits
    bonus_credits = Credit.where("user_id = ? and credit_type = 'Card Bonus' and card_id = ?", self.user.id, self.card.id).first
    logger.info "Initial card credits = #{bonus_credits.amount unless bonus_credits.blank?}"
    return if bonus_credits
    ## TODO check for source of credits later may be from meet
    logger.info "Awarding Card bonus credits- #{self.card.initial_credits}\n"
    Credit.create( :user_id => self.user.id,
                   :amount => self.card.initial_credits.to_i,
                   :credit_type => "Card Bonus",
                   :card_id => self.card.id,
                   :meet_id => self.card.meet_id,
                   :description => "Card Bonus for #{self.card.name} ",
                   :track_id => self.card.meet.track.id,  
                   :level => 'Yellow'      
                 )

  end

  def check_for_race_bonus
    ## see if bettor has been given initial card credits
    bonus_credits = Credit.where("user_id = ? and credit_type = 'Race Bonus' and race_id = ?", self.user.id, self.race.id).first
    logger.info "Initial race credits = #{bonus_credits.amount unless bonus_credits.blank?}"
    return if bonus_credits
    ## TODO check for source of credits later may be from meet
    logger.info "Awarding race bonus credits- #{self.race.initial_credits}\n"
    Credit.create( :user_id => self.user.id,
                   :amount => self.race.initial_credits,
                   :credit_type => "Race Bonus",
                   :race_id => self.race.id,
                   :card_id => self.card.id,
                   :meet_id => self.card.meet_id,
                   :description => "Race Bonus for #{self.race.name}",
                   :track_id => self.card.meet.track.id,  
                   :level => 'Yellow'      
                 )

  end
end
