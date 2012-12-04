class RankingsController < ApplicationController
  # GET /rankings
  # GET /rankings.json
  def index
    if params[:league_id]
      league_meet_ranking
    elsif params[:meet_id]
      meet_ranking
    elsif params[:card_id]
      card_ranking
    else
      @rankings = Ranking.all
    end
   
    #@rank = Ranking.where("amount > ?", @myrank.amount).index(@myrank)
   # @rank = @rank.to_i + 1 
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rankings }
    end
  end

  def league_meet_ranking
    @meet = Meet.find(params[:meet_id])
    @league = League.find(params[:league_id])
    @track = @meet.track
    @myrank = nil
    unless current_user.nil?
      @myrank = Ranking.where("user_id = ? and meet_id = ?", current_user.id, @meet.id).first
    end
   # @rank = Ranking.count(:order => "amount", :conditions => ['amount > (?)', @myrank.amount])
    ## this counts the records where amount is greater thant the user
    user_ids = Leagueuser.where("league_id = ?", @league.id).pluck(:user_id)
    
    @rankings = @meet.rankings.where(:user_id => user_ids).order("amount desc")
    logger.info "league user_ids = #{user_ids}"
    unless @myrank.blank?
      @rank = Ranking.where("amount > ? and user_id IN (?) and meet_id = ?", @myrank.amount, user_ids, @meet.id).order("amount desc").count
    else
      @rank = Ranking.where("meet_id = ?",  @meet.id).count
    end

  end
  def meet_ranking

    @meet = Meet.find(params[:meet_id])
    @rankings = @meet.rankings.order("amount desc")
    @track = @meet.track
    @myrank = Ranking.where("user_id = ? and meet_id = ?", current_user.id, @meet.id).first
   # @rank = Ranking.count(:order => "amount", :conditions => ['amount > (?)', @myrank.amount])
    ## this counts the records where amount is greater thant the user
    unless @myrank.blank?
      @rank = Ranking.where("amount > ? and user_id =? and meet_id = ?", @myrank.amount, current_user.id, @meet.id).order("amount desc").count
    else
      @rank = Ranking.where("meet_id = ?",  @meet.id).count
    end

  end

  def card_ranking
    @card = Card.find(params[:card_id])
    @meet = @card.meet
    @rankings = @card.rankings.order("amount desc")
    @track = @card.meet.track
    @mycardrank = Ranking.where("user_id = ? and card_id = ?", current_user.id, @card.id).first
   # @rank = Ranking.count(:order => "amount", :conditions => ['amount > (?)', @myrank.amount])
    ## this counts the records where amount is greater thant the user
    unless @mycardrank.blank?
      @rank = Ranking.where("amount > ? and user_id =? and card_id = ?", @mycardrank.amount, current_user.id, @card.id).order("amount desc").count
    else
      @rank = Ranking.where("card_id = ?",  @card.id).count
    end



  end
  # GET /rankings/1
  # GET /rankings/1.json
  def show
    @ranking = Ranking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ranking }
    end
  end

  # GET /rankings/new
  # GET /rankings/new.json
  def new
    @ranking = Ranking.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ranking }
    end
  end

  # GET /rankings/1/edit
  def edit
    @ranking = Ranking.find(params[:id])
  end

  # POST /rankings
  # POST /rankings.json
  def create
    @ranking = Ranking.new(params[:ranking])

    respond_to do |format|
      if @ranking.save
        format.html { redirect_to @ranking, notice: 'Ranking was successfully created.' }
        format.json { render json: @ranking, status: :created, location: @ranking }
      else
        format.html { render action: "new" }
        format.json { render json: @ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rankings/1
  # PUT /rankings/1.json
  def update
    @ranking = Ranking.find(params[:id])

    respond_to do |format|
      if @ranking.update_attributes(params[:ranking])
        format.html { redirect_to @ranking, notice: 'Ranking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rankings/1
  # DELETE /rankings/1.json
  def destroy
    @ranking = Ranking.find(params[:id])
    @ranking.destroy

    respond_to do |format|
      format.html { redirect_to rankings_url }
      format.json { head :no_content }
    end
  end
end
