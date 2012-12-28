class GatesController < ApplicationController
  # GET /gates
  # GET /gates.json

  def scratch
    @gate = Gate.find(params[:id])
    @gate.scratch
    
    redirect_to race_path(@gate.race), notice: 'Gate was successfully scratched.'
  end

  def index
    @gates = Gate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gates }
    end
  end

  # GET /gates/1
  # GET /gates/1.json
  def show
    @gate = Gate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gate }
    end
  end

  # GET /gates/new
  # GET /gates/new.json
  def new
    @gate = Gate.new
    @gate.race_id = params[:race_id]
    @race = Race.find(params[:race_id])
    @track = @race.track
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gate }
    end
  end

  # GET /gates/1/edit
  def edit
    @gate = Gate.find(params[:id])
  end

  # POST /gates
  # POST /gates.json
  def create
    @gate = Gate.new(params[:gate])

    respond_to do |format|
      if @gate.save
        format.html { redirect_to @gate.race, notice: 'Gate was successfully created.' }
        format.json { render json: @gate, status: :created, location: @gate }
      else
        format.html { render action: "new" }
        format.json { render json: @gate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gates/1
  # PUT /gates/1.json
  def update
    @gate = Gate.find(params[:id])

    respond_to do |format|
      if @gate.update_attributes(params[:gate])
        format.html { redirect_to @gate.race, notice: 'Gate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gates/1
  # DELETE /gates/1.json
  def destroy
    @gate = Gate.find(params[:id])
    @gate.destroy

    respond_to do |format|
      format.html { redirect_to gates_url }
      format.json { head :no_content }
    end
  end
end
