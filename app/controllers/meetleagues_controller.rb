class MeetleaguesController < ApplicationController
  # GET /meetleagues
  # GET /meetleagues.json
  def index
    @league = League.find(params[:id])
    @meetleagues = Meetleague.where("league_id = ?", @league.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meetleagues }
    end
  end

  # GET /meetleagues/1
  # GET /meetleagues/1.json
  def show
    @meetleague = Meetleague.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meetleague }
    end
  end

  # GET /meetleagues/new
  # GET /meetleagues/new.json
  def new
    @meetleague = Meetleague.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meetleague }
    end
  end

  # GET /meetleagues/1/edit
  def edit
    @meetleague = Meetleague.find(params[:id])
  end

  # POST /meetleagues
  # POST /meetleagues.json
  def create
    @meetleague = Meetleague.new(params[:meetleague])

    respond_to do |format|
      if @meetleague.save
        format.html { redirect_to @meetleague, notice: 'Meetleague was successfully created.' }
        format.json { render json: @meetleague, status: :created, location: @meetleague }
      else
        format.html { render action: "new" }
        format.json { render json: @meetleague.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meetleagues/1
  # PUT /meetleagues/1.json
  def update
    @meetleague = Meetleague.find(params[:id])

    respond_to do |format|
      if @meetleague.update_attributes(params[:meetleague])
        format.html { redirect_to @meetleague, notice: 'Meetleague was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meetleague.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetleagues/1
  # DELETE /meetleagues/1.json
  def destroy
    @meetleague = Meetleague.find(params[:id])
    @meetleague.destroy

    respond_to do |format|
      format.html { redirect_to meetleagues_url }
      format.json { head :no_content }
    end
  end
end
