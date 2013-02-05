##http://stackoverflow.com/questions/6318959/rails-how-to-render-a-view-partial-in-a-model
require 'action_pusher'

class ContractsPusher < ActionPusher
  def initialize(contract)
    @contract = contract
    @user = @contract.user
      @gate = @contract.gate
      @race = @gate.race
      @card = @race.card
      @meet = @card.meet
      @track = @meet.track
  end



  def update_open_contracts(contract = nil)
    default_url_options[:host] = contract.gate.race.card.meet.track.site.domain


      @contracts = @gate.contracts.where("user_id = ? and status = 'Open'", @contract.user_id) 
      @balance = @gate.contracts.where("user_id = ? ", @user.id).sum(:price)
      channel = "user_open_contracts#{@user.id}"
      Pushable.new channel, 'updateOpenContractsEvent',  render(template: 'contracts_pusher/open_contracts')

      ## update all Open Options
      channel = "my_open_contracts#{@user.id}"
      @open_contracts = Contract.where("user_id = ? and status = 'Open'", @contract.user_id) 
      Pushable.new channel, 'updateAllOpenContractsEvent',  render(template: 'users/my_open_contracts')
  end
end
