class LeaguesController < ApplicationController
  # GET /leagues
  # GET /leagues.json

  def join
     @league = League.find(params[:id])
     @status = params[:status]
     
     leagueuser = Leagueuser.find_or_create_by_user_id_and_league_id(:user_id =>current_user.id, :league_id =>@league.id, :nickname => current_user.name, :active => true, :status => @status)
         if session[:provider] == 'facebook'
            current_user.facebook.put_wall_post({:message => "I joined the league #{@league.name} on  Fantasy Odds Maker.", :link => "http://www.fantasyoddsmaker.com/league#{@league.id}"})
         end
       redirect_to @league, notice: 'Welcome. You have successfully joined!.'
  end

  def quit
     @league = League.find(params[:id])
     leagueuser = Leagueuser.where(:user_id =>current_user.id, :league_id =>@league.id).first
     leagueuser.quit
       redirect_to @league, notice: "Goodbye. You have successfully been removed as member of #{@league.name}!."
  end

  def index
    @leagues = League.page(params[:page]).per_page(30).order('name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leagues }
    end
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    @league = League.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @league }
    end
  end

  # GET /leagues/new
  # GET /leagues/new.json
  def new
    @league = League.new
    @league.owner_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @league }
    end
  end

  # GET /leagues/1/edit
  def edit
    @league = League.find(params[:id])
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(params[:league])
    @league.owner_id = current_user.id
    @league.status = 'Public'

    respond_to do |format|
      if @league.save
     leagueuser = Leagueuser.find_or_create_by_user_id_and_league_id(:user_id =>current_user.id, :league_id =>@league.id, :nickname => current_user.name, :active => true, :status => 'Owner')
        format.html { redirect_to @league, notice: 'League was successfully created.' }
        format.json { render json: @league, status: :created, location: @league }
      else
        format.html { render action: "new" }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leagues/1
  # PUT /leagues/1.json
  def update
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html { redirect_to leagues_url }
      format.json { head :no_content }
    end
  end
end
