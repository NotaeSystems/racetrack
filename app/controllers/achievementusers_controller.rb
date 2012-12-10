class AchievementusersController < ApplicationController
  # GET /achievementusers
  # GET /achievementusers.json
  def index
    @achievementusers = Achievementuser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @achievementusers }
    end
  end

  # GET /achievementusers/1
  # GET /achievementusers/1.json
  def show
    @achievementuser = Achievementuser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @achievementuser }
    end
  end

  # GET /achievementusers/new
  # GET /achievementusers/new.json
  def new
    @achievementuser = Achievementuser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @achievementuser }
    end
  end

  # GET /achievementusers/1/edit
  def edit
    @achievementuser = Achievementuser.find(params[:id])
  end

  # POST /achievementusers
  # POST /achievementusers.json
  def create
    @achievementuser = Achievementuser.new(params[:achievementuser])

    respond_to do |format|
      if @achievementuser.save
        format.html { redirect_to @achievementuser, notice: 'Achievementuser was successfully created.' }
        format.json { render json: @achievementuser, status: :created, location: @achievementuser }
      else
        format.html { render action: "new" }
        format.json { render json: @achievementuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /achievementusers/1
  # PUT /achievementusers/1.json
  def update
    @achievementuser = Achievementuser.find(params[:id])

    respond_to do |format|
      if @achievementuser.update_attributes(params[:achievementuser])
        format.html { redirect_to @achievementuser, notice: 'Achievementuser was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @achievementuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /achievementusers/1
  # DELETE /achievementusers/1.json
  def destroy
    @achievementuser = Achievementuser.find(params[:id])
    @achievementuser.destroy

    respond_to do |format|
      format.html { redirect_to achievementusers_url }
      format.json { head :no_content }
    end
  end
end
