class ContractsController < ApplicationController
  # GET /contracts
  # GET /contracts.json

  before_filter :check_for_opposing_party, :only => [:buy]
  before_filter :check_for_level, :only => [:buy]

  def open_contracts
    if params[:track_id]
      @contracts = @track.contracts.where("user_id = ? and status = 'Open'", current_user.id)


    end
  end

  def buy
    
    @price = nil
    @gate = Gate.where(:id => params[:gate_id]).first
    @market = params[:market]
    if params[:price]
      @price = params[:price].to_i
    else
      @price = nil
    end

    @offer_type = params[:offer_type]
    @number = params[:number]
    offer_id = params[:offer_id]
    offer = Offer.find(params[:offer_id])
    if offer.user_id == current_user.id
       redirect_to edit_offer_path(offer), :notice => "This is your offer."
    else
      @contract = Contract.buy(@gate, @number, @price, @market, current_user, @offer_type, @level, offer_id)
      if @contract
       if @offer_type == 'Buy'
       #  redirect_to race_path(@gate.race), :notice => "Success! You have bought #{@contract.number} #{@offer_type} contract(s) at #{@contract.price}."
       elsif @offer_type == 'Sell'
  #       redirect_to race_path(@gate.race), :notice => "Success! You have sold #{@contract.number} #{@offer_type} contract(s) at #{@contract.price}."
       end
      else
    #   redirect_to race_path(@gate.race), :notice => "Sorry! No contract available."
      end
    end
    render :nothing => true
  end

  def index
    if params[:gate_id]
      @gate = Gate.find(params[:gate_id])
      if params[:user_id]
        user = User.find(params[:user_id])
        @contracts = @gate.contracts.where(:user_id => user.id, :status => 'Open')
      else
        @contracts = @gate.contracts.where(:status => 'Open')
      end
    else
      @contracts = @gate.contracts
    end
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
      params.require(:contract).permit(:contract_type, :gate_id, :number, :race_id, :site_id, :user_id, :level)
    end

    def check_for_level
    @gate = Gate.where(:id => params[:gate_id]).first
      if  current_user.yellow_card_credits_balance(@gate.race.card).to_i >= @price.to_i
        @level = 'Yellow'
        return
      elsif current_user.white_card_credits_balance.to_i >= @price.to_i
        @level = 'White'
        return
      elsif current_user.red_card_credits_balance.to_i >= @price.to_i
        @level = 'Red'
        return
      end
      redirect_to race_path(@gate.race) , :notice => "Sorry! Not enought points of one type to conduct purchase."
    end

    def check_for_opposing_party

    end
end
