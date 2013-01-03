class BetsController < ApplicationController
  # GET /bets
  # GET /bets.json
  before_filter :login_required_filter
  before_filter :check_for_initial_credits, :only => [:new, :exacta]
  before_filter :check_credits_for_zero_balance, :only => [:new, :exacta]

  before_filter :check_for_post_time, :only => [:create, :create_exacta]
  before_filter :check_credits_for_sufficient_balance, :only => [:create, :create_exacta]



  def index
    if params[:user]
      @bets = Bet.where(:user_id => params[:user] ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:race]
      @bets = Bet.where(:race_id =>params[:race] ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:card]
      @bets = Bet.where(:card_id =>params[:card] ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:trac]
      @bets = Bet.where(:track_id =>params[:track] ).order('created_at DESC').page(params[:page]).per_page(30)
    else
      @bets = Bet.order('created_at DESC').page(params[:page]).per_page(30)
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
      @gate = Gate.find(params[:gate_id])
     @race = Race.find(params[:race_id])
 
     @card = @race.card
     @meet = @card.meet
     @track = @meet.track
    if current_user
      @bet = Bet.new
      @bet.horse_id = @horse.id
      @bet.user_id = current_user.id
      @bet.meet_id = @race.card.meet.id
      @bet.race_id = @race.id
      @bet.card_id = @card.id  
      @bet.track_id = @track.id   
      @bet.gate_id = @gate.id 
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
    @race = Race.find(params[:bet][:race_id])
    @gate = Gate.find(params[:bet][:gate_id])
    @gate = Card.find(params[:bet][:card_id])
    @track = Track.find(params[:bet][:track_id])
    @horse = Horse.find(params[:bet][:horse_id])

    @bet.status = 'Pending'
    @bet.card_id = @card.id
    @bet.site_id = @bet.site_id
    @bet.level = @level
    respond_to do |format|
      if @bet.save

        credit = Credit.create(:user_id => current_user.id,
                           :meet_id => @meet.id,
                           :amount => -@bet.amount,
                           :description => "Deduction for Bet",
                           :card_id => @card.id,
                           :credit_type => "Bet Deduction",
                           :track_id => @track.id,
                           :site_id => @site.id,
                           :race_id => @race.id,
                           :level => @bet.level
                             ) 
     current_user.update_ranking(@meet.id, -@bet.amount)
        format.html { redirect_to race_path(:id => @race.id), notice: "Bet was successfully created. #{daily_bonus_message}" }
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
    @bet.level = @level
    respond_to do |format|
      if @bet.save
         credit = Credit.create(:user_id => current_user.id,
                           :meet_id => @meet.id,
                           :amount => -@bet.amount,
                           :description => "Deduction for Bet",
                           :card_id => @card.id,
                           :credit_type => "Bet Deduction",
                           :track_id => @track.id,
                           :race_id => @race.id,
                           :level => @bet.level
                             ) 
     current_user.update_ranking(@meet.id, -@bet.amount)
        format.html { redirect_to race_path(:id => @race), notice: 'Bet was successfully created.' }
        format.json { render json: @bet, status: :created, location: @bet }
      else
        if @bet.bet_type == 'Exacta'
        format.html { render action: "exacta" }
        elsif @bet.bet_type == 'Trifecta'
           format.html { render action: "trifecta" }

        end
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

  def check_for_initial_credits
    @race = Race.find(params[:race_id])
    @card = @race.card
    @track = @card.meet.track
    ## see if bettor is member of this track
    logger.info "Getting ready to create or find trackuser\n"
    trackuser = Trackuser.find_or_create_by_user_id_and_track_id(:user_id =>current_user.id, :track_id =>@track.id, :role => 'Handicapper', :allow_comments => false, :nickname => current_user.name, :status => 'Member')
    ## see if bettor has been given initial card credits
   # initial_credits = Credit.where("user_id = ? and credit_type = 'Initial' and card_id = ?", current_user.id, @card.id).first
    #logger.info "Initial credits = #{initial_credits.amount unless initial_credits.blank?}"
    #return unless initial_credits.nil?
    ## TODO check for source of credits later may be from meet
    #logger.info "Refreshing credits- #{@card.initial_credits}\n"
    #@card.refresh_credits(current_user, 'Initial', @card.initial_credits)
  end

  def check_credits_for_zero_balance
      @race = Race.find(params[:race_id])
      @card = @race.card
      balance = current_user.credits_balance
      return if balance > 0
      flash[:warning] = "Sorry, you are out of credits for this card."
      redirect_to race_path(:id => @race.id)
  end


  def check_for_post_time
    @race = Race.find(params[:bet][:race_id])
    
    post_time = @race.post_time
    return if post_time > Time.zone.now
    flash[:warning] = "Sorry, post time has passed. No futher betting allowd."
    redirect_to race_path(:id => @race.id)
     
  end


  def check_credits_for_sufficient_balance

      @amount = params[:bet][:amount].to_i
     @race = Race.find(params[:bet][:race_id])
      @card = @race.card
      white_balance = current_user.white_credits_balance
      if white_balance >= 1 && @amount < white_balance
        @level = 'White'
        return
      end
     
      green_balance = current_user.green_credits_balance
      if green_balance >= 1 && @amount < green_balance
        @level = 'Green'
        return
      end

      red_balance = current_user.red_credits_balance
      if red_balance >= 1 && @amount < red_balance
        @level = 'Red'
        return
      end

      flash[:warning] = "Sorry, you do not have enough #{@site.credit_alias}s for this #{@site.bet_alias}. You must use all your White first, then Green, and then Red #{@site.credit_alias}s"
      redirect_to race_path(:id => @race.id)
  end

 


end
