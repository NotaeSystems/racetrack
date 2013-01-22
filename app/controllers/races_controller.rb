class RacesController < ApplicationController
  # GET /races
  # GET /races.json
   before_filter :login_required_filter, :except => [:show]
   before_filter :is_track_manager_filter, :only =>[:edit, :update, :push_message, :close, :cancel, :open, :send_message, :payout]
  before_filter :check_for_winners, :only => [:payout]
  before_filter :check_for_placers, :only => [:payout]
  before_filter :check_for_showers, :only => [:payout]
  before_filter :check_for_site, :only => [:show, :edit]

  def sort
    @race = Race.find(params[:id])
    if user_is_track_manager?(@race.track)
      params[:horse].each_with_index do |id, index|
        Horse.where(:race_id => @race.id).update_all({position: index+1}, {id: id})
      end
    end
    render nothing: true
  end


 def send_message
   channel = 'test_channel'
   id = 'greet'
   message = "Ready to bet?"
   PusherChannel.send_message(channel, id, message)
   #Pusher['test_channel'].trigger('greet', {:greeting => "Hello there!"})
   render :nothing => true
 end

  def close
    status = params[:status]
    @race = Race.find(params[:id])
    ## close out race
    @race.status = status
    @race.save
    flash[:notice] = 'Race status was successfully changed.'
 
    ## award credits to winners
    ## determine odds
    respond_to do |format|
      format.html { redirect_to @race, notice: "Race was successfully #{status}." }
      format.json { render json: @race }
    end
  end


  def cancel
    @race = Race.find(params[:id])
    @race.cancel
    flash[:notice] = 'Race was successfully Cancelled and Bets returned.'
    redirect_to @race
  end

  def payout
    status = params[:status]
    @race = Race.find(params[:id])
    ## payout parimutual
    @race.payout
    ## payout futures
    @race.settle_contracts
    flash[:notice] = 'Race was successfully Paid Out.'
    redirect_to @race
  end

  def index
    @races = @site.races.where(:status => 'Open')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @races }
    end
  end

  # GET /races/1
  # GET /races/1.json



  def show
    @race = Race.find(params[:id])
    @betting_status = @race.betting_status
    @gates = @race.gates.order('number')
    @horses = @race.horses.order('position')
    @track = @race.card.meet.track
    @meet = @race.card.meet
    @comments = @race.comments
    @card = @race.card
    unless current_user.nil?
       @initial_credits = Credit.where("user_id = ? and credit_type = 'Initial' and card_id = ?", current_user.id, @card.id).first
    else
       @initial_credits = nil
    end
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @race }
    end
  end

  # GET /races/new
  # GET /races/new.json
  def new
    card_id = params[:card_id]
    @card = Card.find(card_id)
    @meet = @card.meet
    @race = Race.new
    @track = @card.meet.track
    @race.status = 'Pending'
    @race.post_time = Time.now + 2.hours
    @race.level = 'White'
    @race.win = true
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @race }
    end
  end

  # GET /races/1/edit
  def edit
    @race = Race.find(params[:id])
    @card = @race.card
    @meet = @race.meet
    @track = @card.meet.track
  end

  # POST /races
  # POST /races.json
  def create
    @race = Race.new(params[:race])
    @race.site_id = @site.id
    respond_to do |format|
      if @race.save
        format.html { redirect_to @race, notice: 'Race was successfully created.' }
        format.json { render json: @race, status: :created, location: @race }
      else
        format.html { render action: "new" }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /races/1
  # PUT /races/1.json
  def update
    @race = Race.find(params[:id])

    respond_to do |format|
      if @race.update_attributes(params[:race])
        format.html { redirect_to @race, notice: 'Race was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /races/1
  # DELETE /races/1.json
  def destroy
    @race = Race.find(params[:id])
    @race.destroy

    respond_to do |format|
      format.html { redirect_to races_url }
      format.json { head :no_content }
    end
  end

  private
  def check_for_site
   @race = Race.where(:id => params[:id]).first
   if @race
    return if user_is_admin?
    return if @race.site_id == @site.id
   end
   flash[:notice] = "Race Not Found"
   redirect_to(message_path)

  end

  def is_track_manager_filter
   @race = Race.find(params[:id])
   @track = @race.card.meet.track
   return true if user_is_track_manager?(@track)
   flash[:notice] = "Not Authorized as Track Manager"
   redirect_to(message_path)
  end

  def check_for_winners
    @race = Race.find(params[:id])
    winners = @race.gates.where("finish = 1")
    winners_size = winners.size
    return if winners_size > 0
    flash[:error] = "Cannot pay out there is no winner!"
    redirect_to race_path(:id => @race.id)

  end

  def check_for_placers
    return unless @race.place?
    @race = Race.find(params[:id])
    winners = @race.gates.where("finish = 2")
    winners_size = winners.size
    return if winners_size > 0
    flash[:error] = "Cannot pay out there is no place finish!"
    redirect_to race_path(:id => @race.id)

  end

  def check_for_showers
    return unless @race.show?
    @race = Race.find(params[:id])
    winners = @race.gates.where("finish = 3")
    winners_size = winners.size
    return if winners_size > 0
    flash[:error] = "Cannot pay out there is no show finish!"
    redirect_to race_path(:id => @race.id)

  end
end
