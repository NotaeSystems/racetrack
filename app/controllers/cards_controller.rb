class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json

  def sort
    @card = Card.find(params[:id])
    if user_is_track_manager?(@card.meet.track)
      params[:race].each_with_index do |id, index|
        Race.where(:card_id => @card.id).update_all({position: index+1}, {id: id})
      end
    end
    render nothing: true
  end

  def push_message
    @card = Card.find(params[:card_id])
    @track = @card.meet.track
    @channel = "card#{@card.id}"
    @message = params[:message]

    PusherChannel.send_message(@channel, @channel, @message)

    flash.notice = "Message: #{@message}. Sent OK"
    redirect_to card_path(@card)
  end

 def message
 
   @card = Card.find(params[:id])
   @track = @card.meet.track
   @meet = @card.meet
 end

  def close
    @card = Card.find(params[:id])
    @track = @card.meet.track
    @races = @card.races
    @meet = @card.meet
    @comments = @card.comments
    @card.close
    flash.notice = "Card Closed!"
    redirect_to card_path(@card)
  end

  def open
    @card = Card.find(params[:id])
    @card.status = 'Open'
    @card.save
    flash.notice = "Card Opened!"
    redirect_to card_path(@card)
  end

  def index
    
    @cards = Card.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.json

  def show

    @card = Card.find(params[:id])
    @track = @card.meet.track
    @races = @card.races
    @meet = @card.meet
    @comments = @card.comments
   # @initial_credits = Credit.where("user_id = ? and credit_type = 'Initial' and card_id = ?", current_user.id, @card.id).first
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card }
    end
  end

 def send_message

   Pusher.app_id = '32755'
   Pusher.key = '77e99ef2916328d0067a'
   Pusher.secret = '5b7c2c8b9b9b6256fdeb'
   Pusher['test_channel'].trigger('greet', {:greeting => "Hello there!"})
   render :nothing => true
 end

  # GET /cards/new
  # GET /cards/new.json
  def new
    meet_id = params[:meet_id]
    @card = Card.new
    @card.meet_id = meet_id
    @track = @card.meet.track
    @card.initial_credits = 100
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/1/edit
  def edit
    @card = Card.find(params[:id])
    @track = @card.meet.track
    @races = @card.races
    @meet = @card.meet
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(params[:card])

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render json: @card, status: :created, location: @card }
      else
        format.html { render action: "new" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.json
  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  private 

  def is_track_manager?
   return true if user_is_track_manager?

   end
end
