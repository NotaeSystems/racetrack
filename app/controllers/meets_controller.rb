class MeetsController < ApplicationController
  # GET /meets
  # GET /meets.json

  def refresh_credits
    @meet = Meet.find(params[:id])
    @meet.refresh_credits(current_user)
    respond_to do |format|
        format.html { redirect_to @meet, notice: 'Meet was successfully updated.' }
        format.json { head :no_content }
    end
  end

  def index
    track_id = params[:track_id]
    @track = Track.where("id = ?",track_id).first
    @meets = @track.meets.open
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meets }
    end
  end

  # GET /meets/1
  # GET /meets/1.json
  def show

   
    @meet = Meet.find(params[:id])
    @track = @meet.track
    @cards = @meet.cards
    @comments = @meet.comments
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meet }
    end
  end

  # GET /meets/new
  # GET /meets/new.json
  def new
    @meet = Meet.new
    @track = Track.find(params[:track_id])
    @meet.initial_credits = 100
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meet }
    end
  end

  # GET /meets/1/edit
  def edit
    @meet = Meet.find(params[:id])
    @track = @meet.track
  end

  # POST /meets
  # POST /meets.json
  def create
    @meet = Meet.new(params[:meet])

    respond_to do |format|
      if @meet.save
        format.html { redirect_to @meet, notice: 'Meet was successfully created.' }
        format.json { render json: @meet, status: :created, location: @meet }
      else
        format.html { render action: "new" }
        format.json { render json: @meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meets/1
  # PUT /meets/1.json
  def update
    @meet = Meet.find(params[:id])

    respond_to do |format|
      if @meet.update_attributes(params[:meet])
        format.html { redirect_to @meet, notice: 'Meet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meets/1
  # DELETE /meets/1.json
  def destroy
    @meet = Meet.find(params[:id])
    @meet.destroy
    @track = @meet.track
    respond_to do |format|
      format.html { redirect_to track_url(:id => @track.id) }
      format.json { head :no_content }
    end
  end
end
