##http://stackoverflow.com/questions/6318959/rails-how-to-render-a-view-partial-in-a-model
require 'action_pusher'

class RacesPusher < ActionPusher
  def initialize(race)
    @race = race
  end

  def flash_message(message)
    begin
      default_url_options[:host] = @race.card.meet.track.site.domain
      @message = message
      Pushable.new "race#{@race.id}", 'flash_message', render(template: 'users_pusher/flash_message')
    rescue
      logger.info 'Pusher failed'
    end
    #Pusher.trigger(channel,'race_channel','help' )
  end

  def alert_message(message)
    begin
      default_url_options[:host] = @race.card.meet.track.site.domain
      @message = message
      Pushable.new "race#{@race.id}", 'flash_message', render(template: 'users_pusher/alert_message')
    rescue
      logger.info 'Pusher failed'
    end
  end

  def update_gates(race = nil)
    begin
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
      Pushable.new channel, 'race_channel', render(template: 'races_pusher/update_gates')
    rescue
      logger.info 'Pusher failed'
    end
    #Pusher.trigger(channel,'race_channel','help' )
  end
end
