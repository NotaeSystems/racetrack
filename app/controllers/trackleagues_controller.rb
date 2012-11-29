class TrackleaguesController < ApplicationController
  # GET /trackleagues
  # GET /trackleagues.json
  def index
     @league = League.find(params[:id])
    @trackleagues = Trackleague.where("league_id = ?", @league.id)
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trackleagues }
    end
  end

  # GET /trackleagues/1
  # GET /trackleagues/1.json
  def show
    @trackleague = Trackleague.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trackleague }
    end
  end

  # GET /trackleagues/new
  # GET /trackleagues/new.json
  def new
    @trackleague = Trackleague.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trackleague }
    end
  end

  # GET /trackleagues/1/edit
  def edit
    @trackleague = Trackleague.find(params[:id])
  end

  # POST /trackleagues
  # POST /trackleagues.json
  def create
    @trackleague = Trackleague.new(params[:trackleague])

    respond_to do |format|
      if @trackleague.save
        format.html { redirect_to @trackleague, notice: 'Trackleague was successfully created.' }
        format.json { render json: @trackleague, status: :created, location: @trackleague }
      else
        format.html { render action: "new" }
        format.json { render json: @trackleague.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trackleagues/1
  # PUT /trackleagues/1.json
  def update
    @trackleague = Trackleague.find(params[:id])

    respond_to do |format|
      if @trackleague.update_attributes(params[:trackleague])
        format.html { redirect_to @trackleague, notice: 'Trackleague was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trackleague.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trackleagues/1
  # DELETE /trackleagues/1.json
  def destroy
    @trackleague = Trackleague.find(params[:id])
    @trackleague.destroy

    respond_to do |format|
      format.html { redirect_to trackleagues_url }
      format.json { head :no_content }
    end
  end
end
