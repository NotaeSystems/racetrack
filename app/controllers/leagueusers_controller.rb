class LeagueusersController < ApplicationController
  # GET /leagueusers
  # GET /leagueusers.json
  def index
    if params[:status] == 'Pending'
      @league = League.find(params[:league_id])
     @search = Leagueuser.where(:league_id => @league.id, :status => 'Pending').page(params[:page]).includes(:league, :user).per_page(30).order('nickname').search(params[:q])

    elsif params[:league_id]
      @league = League.find(params[:league_id])
     @search = Leagueuser.where(:league_id => @league.id).page(params[:page]).includes(:league, :user).per_page(30).order('nickname').search(params[:q])
    else
      @league = League.find(params[:q][:league_id_eql])
     @search = Leagueuser.where(:league_id => @league.id).page(params[:page]).includes(:league, :user).per_page(30).order('nickname').search(params[:q])
    end
    @leagueusers = @search.result

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trackusers }
    end
  end

  # GET /leagueusers/1
  # GET /leagueusers/1.json
  def show
    @leagueuser = Leagueuser.find(params[:id])
    @league = League.find(@leagueuser.league_id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @leagueuser }
    end
  end

  # GET /leagueusers/new
  # GET /leagueusers/new.json
  def new
    @leagueuser = Leagueuser.new
    @league = League.find(@leagueuser.league_id)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @leagueuser }
    end
  end

  # GET /leagueusers/1/edit
  def edit
    @leagueuser = Leagueuser.find(params[:id])
    @league = League.find(@leagueuser.league_id)
  end

  # POST /leagueusers
  # POST /leagueusers.json
  def create
    @leagueuser = Leagueuser.new(params[:leagueuser])

    respond_to do |format|
      if @leagueuser.save
        format.html { redirect_to @leagueuser, notice: 'Leagueuser was successfully created.' }
        format.json { render json: @leagueuser, status: :created, location: @leagueuser }
      else
        format.html { render action: "new" }
        format.json { render json: @leagueuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leagueusers/1
  # PUT /leagueusers/1.json
  def update
    @leagueuser = Leagueuser.find(params[:id])
       @league = League.find(@leagueuser.league_id) 
    respond_to do |format|
      if @leagueuser.update_attributes(params[:leagueuser])
        format.html { redirect_to leagueusers_url(:league_id => @league.id), notice: 'Leagueuser was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leagueuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagueusers/1
  # DELETE /leagueusers/1.json
  def destroy
    @leagueuser = Leagueuser.find(params[:id])
    @league = League.find(@leagueuser.league_id)
    @leagueuser.quit

    respond_to do |format|
      format.html  { redirect_to leagueusers_url(:id => @league.id), notice: 'League Member was successfully removed.' }
      format.json { head :no_content }
    end
  end
end
