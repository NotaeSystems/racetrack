class OffersController < ApplicationController
  # GET /offers
  # GET /offers.json

    before_filter :login_required_filter
  before_filter :check_for_open_race, :only => [:new]
  before_filter :check_for_matching_offer, :only => [:create, :update]
  

  def cancel
    @offer = Offer.find(params[:id])
    
    @offer.status = 'Cancelled'
    @offer.save
    flash[:success] = "Offer Cancelled"
    redirect_to offers_path(:gate_id => @offer.gate_id)
  end

  def index
    if params[:gate_id]
      @gate = Gate.find(params[:gate_id])
      @race = @gate.race
      @card = @race.card
      @meet = @card.meet
      @track = @meet.track
      #@buy_offers = @gate.offers.where("offer_type = 'Buy' and expires > ?", Time.now).order('price')
      @buy_offers = @gate.offers.where("offer_type = 'Buy' and status = 'Pending' and expires > ? ", Time.now).order('price desc')
      @best_buy_offer =  @gate.offers.where("offer_type = 'Buy' and status = 'Pending' and expires > ?", Time.now, ).order('price desc').first


     # @sell_offers = @gate.offers.where("offer_type = 'Sell' and expires > ?", Time.now).order('price desc')
      @sell_offers = @gate.offers.where("offer_type = 'Sell' and status = 'Pending' and expires > ?", Time.now ).order('price')
      @best_sell_offer =  @gate.offers.where("offer_type = 'Sell' and status = 'Pending' and expires > ? ", Time.now  ).order('price').first

      @contracts = @gate.contracts.where("user_id = ? and status = 'Open'", current_user.id) 
      @balance = @gate.contracts.where("user_id = ? ", current_user.id).sum(:price)
    else
      @contracts = @site.contracts.where("status = 'Open'") 
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.html.erb
      format.json { render json: @offers }
    end
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    @offer = Offer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offer }
    end
  end

  # GET /offers/new
  # GET /offers/new.json
  def new
    @gate = Gate.find(params[:gate_id])
   
    @offer = Offer.new
    @offer.gate_id = @gate.id
    @offer.user_id = current_user.id
    @offer.market = 'Market'
    @offer.number = 1
    @offer.offer_type = params[:offer_type]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offer }
    end
  end

  # GET /offers/1/edit
  def edit
    @offer = Offer.find(params[:id])
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(offer_params)
    race = @offer.gate.race 
    @offer.status = 'Pending'
    @offer.card_id = race.card_id
    @offer.meet_id = race.meet_id
    @offer.track_id = race.track_id
    @offer.site_id = @site.id
    ### determine expiration date of offer
    post_time = race.post_time
    expires = Chronic.parse(params[:offer][:from_now])  
    if expires.blank?
      @offer.expires = post_time
    elsif expires > post_time
      @offer.expires = post_time
    elsif expires < Time.now
      @offer.expires = post_time
    else
      @offer.expires = expires
    end
    ######################################3

    respond_to do |format|
      if @offer.save
        format.html { redirect_to offers_path(:gate_id => @offer.gate_id), notice: 'Offer was successfully created.' }
        format.json { render json: @offer, status: :created, location: @offer }
      else
        @gate = @offer.gate
        format.html { render action: "new" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    @offer = Offer.find(params[:id])
        ### determine expiration date of offer
    race = @offer.gate.race 
    post_time = race.post_time
    expires = Chronic.parse(params[:offer][:from_now])  
    if expires.blank?
      @offer.expires = post_time
    elsif expires > post_time
      @offer.expires = post_time
    elsif expires < Time.now
      @offer.expires = post_time
    else
      @offer.expires = expires
    end
    respond_to do |format|
      if @offer.update_attributes(offer_params)
        format.html { redirect_to offers_path(:gate_id => @offer.gate_id), notice: 'Offer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy

    respond_to do |format|
      format.html { redirect_to offers_user_url(:id => current_user.id) }
      format.json { head :no_content }
    end
  end

  private

    def check_for_open_race
      gate_id = params[:gate_id] 
      gate = Gate.where(:id => gate_id).first
      race = gate.race
      if race.status == 'Open'
        return
      else
        flash[:error] = "The race is not open for betting."
        redirect_to offers_path(:gate_id => gate_id)
      end
    end

    def check_for_matching_offer
     # @offer = Offer.find(params[:offer][:id])
      gate_id = params[:offer][:gate_id] 
      gate = Gate.where(:id => gate_id).first
      number = params[:offer][:number].to_i
      price = params[:offer][:price].to_i   
      offer_type = params[:offer][:offer_type] 
      offer_id = nil           
      ## if offer is buy offer and there is an equal or lower priced sell offer then match
      if offer_type == 'Buy'
        @contract = Contract.buy(gate, number, price, 'market', current_user, offer_type, offer_id)
      else
        @contract = Contract.buy(gate, number, price, 'market', current_user, offer_type, offer_id)
      end
       if @contract
        ## found an existing sell offer that could be matched and a contract was created
        flash[:success] = "There was an existing  offer of #{@contract.price} and #{offer_type} Option was created at #{@contract.price}"
        redirect_to offers_path(:gate_id => gate_id)
       end

    end
    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def offer_params
      params.require(:offer).permit(:expires, :gate_id, :market, :number, :offer_type, :price, :user_id, :from_now)
    end
end
