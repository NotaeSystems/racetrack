class RacesController < ApplicationController
  # GET /races
  # GET /races.json
  before_filter :check_for_winners, :only => [:payout]
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
      format.html { redirect_to @race, notice: 'Race was successfully closed.' }
      format.json { render json: @race }
    end
  end

  def payout
    status = params[:status]
    @race = Race.find(params[:id])
    @race.payout
    flash[:notice] = 'Race was successfully Paid Out.'
    redirect_to @race
  end

  def index
    @races = Race.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @races }
    end
  end

  # GET /races/1
  # GET /races/1.json



  def show
    @race = Race.find(params[:id])
    @horses = @race.horses
    @track = @race.card.meet.track
    @meet = @race.card.meet
    @comments = @race.comments
    @card = @race.card
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @race }
    end
  end

  # GET /races/new
  # GET /races/new.json
  def new
    card_id = params[:card_id]
    @card = Card.find(card_id)
    @race = Race.new
    @track = @card.meet.track
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @race }
    end
  end

  # GET /races/1/edit
  def edit
    @race = Race.find(params[:id])
    @card = @race.card
  end

  # POST /races
  # POST /races.json
  def create
    @race = Race.new(params[:race])

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

  def check_for_winners
    @race = Race.find(params[:id])
    winners = @race.horses.where("finish = 1")
    winners_size = winners.size
    return if winners_size > 0
    flash[:error] = "Cannot pay out there is no winner!"
    redirect_to race_path(:id => @race.id)

  end
end
