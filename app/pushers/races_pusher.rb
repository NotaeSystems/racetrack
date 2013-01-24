##http://stackoverflow.com/questions/6318959/rails-how-to-render-a-view-partial-in-a-model
require 'action_pusher'

class RacesPusher < ActionPusher
  def initialize(race)
    @race = race
  end



  def update_gates(race = nil)
    default_url_options[:host] = race.card.meet.track.site.domain
    @race = race
    @card = @race.card
    @betting_status = @race.betting_status
    @gates = @race.gates.order('number')
    @horses = @race.horses.order('position')
    @track = @race.card.meet.track
    @meet = @race.card.meet
    @comments = @race.comments
    channel = "race#{@race.id}"
    Pushable.new channel, render(template: 'races_pusher/update_gates')
    #Pusher.trigger(channel,'race_channel','help' )
  end
end
