class Contract < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  belongs_to :gate
  belongs_to :race

  attr_accessible :contract_type, :gate_id, :number, :race_id, :site_id, :user_id, :status, :price, :card_id, :meet_id, :track_id

  def self.buy(gate, number, price, market, user, offer_type, offer_id = nil)

    meet = gate.race.card.meet
    race = gate.race
    card = race.card
    track = race.track
    if offer_type == 'Buy' 
    ## user wants to buy an option
        ### find best sell offer
        logger.debug 'inside buy offer'
        if price
          offer = Offer.where("offer_type = 'Sell' and gate_id = ? and expires > ? and status = 'Pending' and price < ? and user_id != ?", gate.id, Time.now, price + 1, user.id).order('price').first
        else
          offer = Offer.where("offer_type = 'Sell' and gate_id = ? and expires > ? and status = 'Pending'  and user_id != ?", gate.id, Time.now, user.id).order('price').first 
        end

       logger.debug 'cannot find offer' if offer.nil?
        if offer 
       logger.debug 'found a sell offer' 
          if offer.user_id == user.id
            logger.debug 'checking to see if offer.user_id  equal user.id'
            return
            logger.debug 'offer.user_id does not equal user.id'
          end
        if offer_id
          logger.debug "checking to see if #{offer_id} equals #{offer.id}"
          if offer_id.to_i == offer.id
            logger.debug 'offer_id equals offer.id'
          else
            return 
          end

        end
          ### close offer
            offer.status = 'Completed'
            offer.save
          ## create Buyers contract
          contract = Contract.create( :user_id => user.id,
                           :status => 'Open',
                           :gate_id => gate.id,
                           :race_id => race.id,
                           :card_id => card.id,
                           :meet_id => meet.id,
                           :track_id => track.id,
                           :number => number,
                           :contract_type => 'Owner',
                           :site_id => race.site_id,
                           :price => -offer.price
                         )
        credit = Credit.create(:user_id =>user.id,
                           :meet_id => meet.id,
                           :amount => -(offer.price),
                           :description => "Bought Option",
                           :card_id => card.id,
                           :credit_type => "Bought",
                           :track_id => track.id,
                           :site_id => track.site.id,
                           :race_id => race.id,
                           :level => 'White'
                             ) 
          ## create Sellers contract
          contract = Contract.create( :user_id => offer.user_id,
                           :status => 'Open',
                           :gate_id => gate.id,
                           :race_id => race.id,
                           :card_id => card.id,
                           :meet_id => meet.id,
                           :track_id => track.id,
                           :number => number,
                           :contract_type => 'Seller',
                           :site_id => race.site_id,
                           :price => offer.price
                         )
         credit = Credit.create(:user_id =>offer.user.id,
                           :meet_id => meet.id,
                           :amount => offer.price,
                           :description => "Sold Option",
                           :card_id => card.id,
                           :credit_type => "Sold",
                           :track_id => track.id,
                           :site_id => track.site.id,
                           :race_id => race.id,
                           :level => 'White'
                             ) 

          seller = offer.user
          buyer = user
          ### charge buyer and credit seller
          seller.update_race_ranking(race, offer.price, 'White')
          buyer.update_race_ranking(race, -offer.price, 'White')

          gate.settle_contracts(seller)
          gate.settle_contracts(buyer)
          return contract
        else
          logger.debug 'Cannot find offer that matches'
          return
        end
     
  
    

    end

    ## find best sell offer 
    if offer_type == 'Sell' 
    ## user looking to sell and looking for best buy offer
        ### find best buy offer
        if price
          offer = Offer.where("offer_type = 'Buy' and gate_id = ? and expires > ? and status = 'Pending' and price > ? and user_id != ?", gate.id, Time.now, price -1, user.id).order('price').first 
        else
          offer = Offer.where("offer_type = 'Buy' and gate_id = ? and expires > ? and status = 'Pending' and user_id != ?", gate.id, Time.now, user.id).order('price').first 
        end
        if offer 
          if offer.user_id == user.id
            return
          end
        if offer && offer_id
          return unless offer_id.to_i == offer.id
        end
          ### close offer
            offer.status = 'Completed'
            offer.save
          ## create Sellers contract
          contract = Contract.create( :user_id => user.id,
                           :status => 'Open',
                           :gate_id => gate.id,
                           :race_id => race.id,
                           :card_id => card.id,
                           :meet_id => meet.id,
                           :track_id => track.id,
                           :track_id => track.id,
                           :number => number,
                           :contract_type => 'Seller',
                           :price => offer.price
                         )
          ## create Buyers contract
          contract = Contract.create( :user_id => offer.user_id,
                           :status => 'Open',
                           :gate_id => gate.id,     
                           :card_id => card.id,
                           :race_id => race.id,
                           :card_id => card.id,
                           :meet_id => meet.id,
                           :track_id => track.id,
                           :number => number,
                           :contract_type => 'Owner',
                           :price => -offer.price
                         )
          buyer = offer.user
          seller = user
          ### charge buyer and credit seller
        Credit.create( :user_id => user.id,
                   :meet_id => gate.race.meet_id,
                   :amount => offer.price,
                   :credit_type => 'Option',
                   :card_id => gate.race.card.id,
                   :description => "Sold Option: #{gate.horse.name} on #{gate.race.name}",
                   :track_id => gate.race.track_id,
                   :site_id => gate.race.site_id, 
                   :level => 'Red',
                   :race_id => gate.race.id                
                 )
        ## 
        Credit.create( :user_id => offer.user.id,
                   :meet_id => gate.race.meet_id,
                   :amount => -(offer.price),
                   :credit_type => 'Contract',   
                   :card_id => gate.race.card.id,
                   :description => "Bought Option: #{gate.horse.name} on #{gate.race.name}",
                   :track_id => gate.race.track_id,
                   :site_id => gate.race.site_id, 
                   :level => 'Red',
                   :race_id => gate.race.id                
                 )          
              

          seller.update_race_ranking(race, offer.price, 'White')
          buyer.update_race_ranking(race, -offer.price, 'White')

          gate.settle_contracts(seller)
          gate.settle_contracts(buyer)
          return contract
        else
          return
        end
      
    end
  end


end
