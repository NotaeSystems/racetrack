class BetsController < ApplicationController
  # GET /bets
  # GET /bets.json
    before_filter :login_required
  before_filter :check_for_initial_credits, :only => [:new, :exacta]
  before_filter :check_for_post_time, :only => [:create, :create_exacta]
  before_filter :check_credits_for_zero_balance, :only => [:new, :exacta]
  before_filter :check_credits_for_sufficient_balance, :only => [:create, :create_exacta]



  def index
    if params[:user]
      @bets = Bet.where(:user_id => params[:user] ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:race]
      @bets = Bet.where(:race_id =>params[:race] ).page(params[:page]).per_page(30)
    elsif params[:card]
      @bets = Bet.where(:card_id =>params[:card] ).page(params[:page]).per_page(30)
    elsif params[:trac]
      @bets = Bet.where(:track_id =>params[:track] ).page(params[:page]).per_page(30)
    else
      @bets = Bet.page(params[:page]).per_page(30)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bets }
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    @bet = Bet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bet }
    end
  end

  def exacta

      @race = Race.find(params[:race_id])
      @meet = @race.card.meet
      @card = @race.card
      @track = @race.track
    if current_user
      @bet = Bet.new
      @bet.user_id = current_user.id
      @bet.meet_id = @race.card.meet.id
      @bet.race_id = @race.id
      @bet.bet_type = 'Exacta'
      
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @bet }
      end
   else

      respond_to do |format|
        format.html{ redirect_to race_path(:id => @horse.race.id), notice: "You must be logged in to bet" }
        format.json { render json: @bet }
     end
    end
  end

  def trifecta

      @race = Race.find(params[:race_id])
      @meet = @race.card.meet
      @card = @race.card
      @track = @race.track
    if current_user
      @bet = Bet.new
      @bet.user_id = current_user.id
      @bet.meet_id = @race.card.meet.id
      @bet.race_id = @race.id
      @bet.bet_type = 'Trifecta'
      
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @bet }
      end
   else

      respond_to do |format|
        format.html{ redirect_to race_path(:id => @horse.race.id), notice: "You must be logged in to bet" }
        format.json { render json: @bet }
     end
    end
  end
  # GET /bets/new
  # GET /bets/new.json


  def new

      @horse = Horse.find(params[:horse_id])
      @meet = @horse.race.card.meet
    if current_user
      @bet = Bet.new
      @bet.horse_id = @horse.id
      @bet.user_id = current_user.id
      @bet.meet_id = @horse.race.card.meet.id
      @bet.race_id = @horse.race.id
      
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @bet }
      end
   else

      respond_to do |format|
        format.html{ redirect_to race_path(:id => @horse.race.id), notice: "You must be logged in to bet" }
        format.json { render json: @bet }
     end
    end
  end

  # GET /bets/1/edit
  def edit
    @bet = Bet.find(params[:id])
  end

  # POST /bets
  # POST /bets.json
  def create
    @bet = Bet.new(params[:bet])
    @meet = Meet.find(params[:bet][:meet_id])
    @track = @meet.track
    @horse = Horse.find(params[:bet][:horse_id])
    @card = @horse.race.card
    @bet.status = 'Pending'
    @bet.card_id = @card.id
    respond_to do |format|
      if @bet.save
         credit = Credit.create(:user_id => current_user.id,
                           :meet_id => @meet.id,
                           :amount => -@bet.amount,
                           :description => "Deduction for Bet",
                           :card_id => @card.id,
                           :credit_type => "Bet Deduction",
                           :track_id => @track.id
                             ) 
     current_user.update_ranking(@meet.id, -@bet.amount)
        format.html { redirect_to race_path(:id => @horse.race), notice: 'Bet was successfully created.' }
        format.json { render json: @bet, status: :created, location: @bet }
      else
        format.html { render action: "new" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_exacta
    @bet = Bet.new(params[:bet])
    @meet = Meet.find(params[:bet][:meet_id])
    @track = @meet.track
    @race = Race.where(:id => params[:bet][:race_id]).first
    #@horse = Horse.find(params[:bet][:horse_id])
    @card = @race.card
    @bet.status = 'Pending'
    @bet.card_id = @card.id
    respond_to do |format|
      if @bet.save
         credit = Credit.create(:user_id => current_user.id,
                           :meet_id => @meet.id,
                           :amount => -@bet.amount,
                           :description => "Deduction for Bet",
                           :card_id => @card.id,
                           :credit_type => "Bet Deduction",
                           :track_id => @track.id
                             ) 
     current_user.update_ranking(@meet.id, -@bet.amount)
        format.html { redirect_to race_path(:id => @race), notice: 'Bet was successfully created.' }
        format.json { render json: @bet, status: :created, location: @bet }
      else
        format.html { render action: "new" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bets/1
  # PUT /bets/1.json
  def update
    @bet = Bet.find(params[:id])

    respond_to do |format|
      if @bet.update_attributes(params[:bet])
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet = Bet.find(params[:id])
    @bet.destroy

    respond_to do |format|
      format.html { redirect_to bets_url }
      format.json { head :no_content }
    end
  end

  private

  def check_credits_for_zero_balance
      @race = Race.find(params[:race_id])
      @card = @race.card
      balance = current_user.card_balance(@card)
      return if balance > 0
      flash[:warning] = "Sorry, you are out of credits for this card."
      redirect_to race_path(:id => @race.id)
  end

  def check_credits_for_sufficient_balance
      @amount = params[:bet][:amount].to_i
      @race = Race.find(params[:bet][:race_id])
      @card = @race.card
      balance = current_user.card_balance(@card)
      return if balance > @amount 
      flash[:warning] = "Sorry, you do not have enough card credits for this bet."
      redirect_to race_path(:id => @race.id)
  end

  def check_for_post_time
    @race = Race.find(params[:bet][:race_id])
    post_time = @race.post_time
    return if post_time > Time.zone.now
    flash[:warning] = "Sorry, post time has passed. No futher betting allowd."
    redirect_to race_path(:id => @race.id)
     
  end
 
  def check_for_initial_credits
    #  @horse = Horse.find(params[:horse_id])
    @race = Race.find(params[:race_id])
    @card = @race.card
    @track = @card.meet.track
    ## see if bettor is member of this track
    logger.info "Getting ready to create or find trackuser\n"
    trackuser = Trackuser.find_or_create_by_user_id_and_track_id(:user_id =>current_user.id, :track_id =>@track.id, :role => 'Handicapper', :allow_comments => false, :nickname => current_user.name, :status => 'Member')
    ## see if bettor has been given initial card credits
    initial_credits = Credit.where("user_id = ? and credit_type = 'Initial' and card_id = ?", current_user.id, @card.id).first
    logger.info "Initial credits = #{initial_credits.amount unless initial_credits.blank?}"
    return unless initial_credits.nil?
    ## TODO check for source of credits later may be from meet
    logger.info "Refreshing credits- #{@card.initial_credits}\n"
    @card.refresh_credits(current_user, 'Initial', @card.initial_credits)
  end

end
