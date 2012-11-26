class BetsController < ApplicationController
  # GET /bets
  # GET /bets.json
    before_filter :login_required
  before_filter :check_for_post_time, :only => [:create]
  before_filter :check_credits_for_zero_balance, :only => [:new]
  before_filter :check_credits_for_sufficient_balance, :only => [:create]

  def index
    @bets = Bet.all

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

  # GET /bets/new
  # GET /bets/new.json
  def new

      @horse = Horse.find(params[:horse_id])
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
    meet = Meet.find(params[:bet][:meet_id])
    horse = Horse.find(params[:bet][:horse_id])

    respond_to do |format|
      if @bet.save
         credit = Credit.create(:user_id => current_user.id,
                           :meet_id => meet.id,
                           :amount => -@bet.amount,
                           :description => "Deduction for Bet",
                           :credit_type => "Bet Deduction"
                             ) 
     current_user.update_ranking(meet.id, -@bet.amount)
        format.html { redirect_to race_path(:id => horse.race), notice: 'Bet was successfully created.' }
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
     
      @horse = Horse.find(params[:horse_id])
      @meet = @horse.race.card.meet
      balance = current_user.meet_balance(@meet)
      return if balance > 0
      flash[:notice] = "Sorry, you are out of credits for this meet."
      redirect_to race_path(:id => @horse.race.id)
  end

  def check_credits_for_sufficient_balance
      @amount = params[:bet][:amount].to_i
      @horse = Horse.find(params[:bet][:horse_id])
      @meet = @horse.race.card.meet
      balance = current_user.meet_balance(@meet)
      return if balance > @amount 
      flash[:notice] = "Sorry, you do not have enough credits for this bet."
      redirect_to race_path(:id => @horse.race.id)
  end

 def check_for_post_time
   @horse = Horse.find(params[:bet][:horse_id])
   post_time = @horse.race.post_time
   return if post_time > Time.zone.now
   flash[:notice] = "Sorry, post time has passed. No futher betting allowd."
   redirect_to race_path(:id => @horse.race.id)
     
   end
 
end
