class HorsesController < ApplicationController
  # GET /horses
  # GET /horses.json
  before_filter :login_required_filter, :except => [:index, :show]

  def sort
    render nothing: true
  end

  def scratch
    @horse = Horse.find(params[:id])
    @horse.scratch
    redirect_to race_path(:id => @horse.race.id), notice: 'Horse was successfully scratched.'
  end

  def index
    @horses = Horse.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @horses }
    end
  end

  # GET /horses/1
  # GET /horses/1.json
  def show
    @horse = Horse.find(params[:id])
    @gates = @horse.gates
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @horse }
    end
  end

  # GET /horses/new
  # GET /horses/new.json
  def new
    @horse = Horse.new
    @race = Race.find(params[:race_id])
    @track = @race.card.meet.track
    @horse.stable_id = @track.id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @horse }
    end
  end

  # GET /horses/1/edit
  def edit
    @horse = Horse.find(params[:id])

    @track = @horse.track


  end

  # POST /horses
  # POST /horses.json
  def create
    @horse = Horse.new(params[:horse])
    @horse.site_id = @site.id
    @race = @horse.race
    respond_to do |format|
      if @horse.save
        Gate.create(:race_id => @horse.race_id,
                    :number => @race.gates.count + 1,
                    :horse_id => @horse.id
                    )
                    
        format.html { redirect_to race_path(:id => @horse.race.id), notice: 'Horse was successfully created.' }
        format.json { render json: @horse, status: :created, location: @horse }
      else
        format.html { render action: "new" }
        format.json { render json: @horse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /horses/1
  # PUT /horses/1.json
  def update
    @horse = Horse.find(params[:id])

    respond_to do |format|
      if @horse.update_attributes(params[:horse])
        format.html { redirect_to race_path(:id => @horse.race.id), notice: 'Horse was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @horse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /horses/1
  # DELETE /horses/1.json
  def destroy
    @horse = Horse.find(params[:id])
    @horse.destroy

    respond_to do |format|
      format.html { redirect_to horses_url }
      format.json { head :no_content }
    end
  end
end
