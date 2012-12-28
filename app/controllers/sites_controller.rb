class SitesController < ApplicationController
 before_filter :user_is_admin_filter?, :except => ['leaderboard']
  # GET /sites
  # GET /sites.json

  def leaderboard
    @users = @site.users.page(params[:page]).per_page(30).order('amount DESC')
    if current_user
      @myrank = @site.users.where(:id => current_user.id).order('amount DESC').index(current_user)
    else
      @myrank = 'Not Ranked'
    end
  end

  def index
    @sites = Site.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    @selected_site = Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.json
  def new
    @selected_site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @selected_site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.json
  def create
    @selected_site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        format.html { redirect_to @selected_site, notice: 'Site was successfully created.' }
        format.json { render json: @selected_site, status: :created, location: @site }
      else
        format.html { render action: "new" }
        format.json { render json: @selected_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.json
  def update
    @selected_site = Site.find(params[:id])

    respond_to do |format|
      if @selected_site.update_attributes(params[:site])
        format.html { redirect_to @selected_site, notice: 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @selected_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @selected+site = Site.find(params[:id])
    @selected_site.destroy

    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end
end
