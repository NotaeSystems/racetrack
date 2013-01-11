class ContractsController < ApplicationController
  # GET /contracts
  # GET /contracts.json

  before_filter :check_for_opposing_party, :only => [:buy]

  def buy
    @gate = Gate.where(:id => params[:gate_id]).first
    @market = params[:market]
    @price = params[:price]
    @offer_type = params[:offer_type]
    @number = params[:number]
    offer_id = params[:offer_id]
    @contract = Contract.buy(@gate, @number, @price, @market, current_user, @offer_type, offer_id)
    if @contract
     redirect_to offers_path(:gate_id => @gate.id), :notice => "Success! You have acquired #{@contract.number} #{@offer_type} contract(s) at #{@contract.price}."
    else
     redirect_to offers_path(:gate_id => @gate.id), :notice => "Sorry! No contract available."
    end
  end

  def index
    @contracts = Contract.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contracts }
    end
  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show
    @contract = Contract.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contract }
    end
  end

  # GET /contracts/new
  # GET /contracts/new.json
  def new
    @contract = Contract.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contract }
    end
  end

  # GET /contracts/1/edit
  def edit
    @contract = Contract.find(params[:id])
  end

  # POST /contracts
  # POST /contracts.json
  def create
    @contract = Contract.new(contract_params)

    respond_to do |format|
      if @contract.save
        format.html { redirect_to @contract, notice: 'Contract was successfully created.' }
        format.json { render json: @contract, status: :created, location: @contract }
      else
        format.html { render action: "new" }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contracts/1
  # PATCH/PUT /contracts/1.json
  def update
    @contract = Contract.find(params[:id])

    respond_to do |format|
      if @contract.update_attributes(contract_params)
        format.html { redirect_to @contract, notice: 'Contract was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
    @contract = Contract.find(params[:id])
    @contract.destroy

    respond_to do |format|
      format.html { redirect_to contracts_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def contract_params
      params.require(:contract).permit(:contract_type, :gate_id, :number, :race_id, :site_id, :user_id)
    end

    def check_for_opposing_party

    end
end
