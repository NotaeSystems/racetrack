class TracksController < ApplicationController
  # GET /tracks
  # GET /tracks.json
  before_filter :login_required_filter, :except => [:join, :index, :show, :tag_cloud]
  before_filter :user_is_site_manager_filter?, :only => [:new]
  before_filter :check_for_number_tracks, :only => [:new]
  before_filter :is_track_manager_filter, :only => [:edit, :update]

  def join

    @track = Track.find(params[:id])
     @status = params[:status]
    @track.join(current_user, @status)
    if @status == 'Member'
      redirect_to @track, notice: "#{@track.name} was successfully joined!" 
    else
      redirect_to @track, notice: "Membership pending in #{@track.name}" 
    end
  end

  def quit
    @track = Track.find(params[:id])
    @track.quit(current_user)
    redirect_to @track, notice: "You were successfully removed as member of #{@track.name}!" 
  end

  def index
        

  if params[:tag]
    @search = @site.tracks.active.page(params[:page]).per_page(30).tagged_with(params[:tag]).order('name').search(params[:q])
    @tracks = @search.result
  elsif params[:owned]
    @search = @site.tracks.where(:owner_id => current_user.id).page(params[:page]).per_page(30).order('name').search(params[:q])
    @tracks = @search.result
  else
    @search = @site.tracks.active.page(params[:page]).per_page(30).order('name').search(params[:q])
    @tracks = @search.result
  end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
  end
  
  def tag_index
  if params[:tag]
    @tracks = Track.tagged_with(params[:tag])
  else
    @tracks = Track.all
  end


  end

  def mytracks
    @tracks = Track.where("owner_id = ?", current_user.id).page(params[:page]).per_page(30).order('name')

  end
  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find(params[:id])
    #@comments = @track.comments
    @pending_members_count = Trackuser.where(:status => 'Pending', :track_id => @track.id).count
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = Track.new
    if params[:user_id]
     @owner = User.find(params[:user_id])
    else
      @owner = current_user
    end
    @track.name = "#{@owner.name}'s Track"
    @track.owner_id = @owner.id
    @track.site_id = @site.id
    @track.track_alias = @site.track_alias
    @track.meet_alias = @site.meet_alias
    @track.card_alias = @site.card_alias
    @track.race_alias = @site.race_alias
    @track.horse_alias =  @site.horse_alias
    @track.member_alias = @site.member_alias
    @track.bet_alias = @site.bet_alias
    @track.credit_alias = @site.credit_alias
    @track.public = true
    @user = current_user
    if current_user.encrypted_password.blank?
      @user.email = ''
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(params[:track])
    @track.site_id = @site.id
    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = Track.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end

  private

  def is_track_manager_filter
   return true if current_user.has_role? :admin
   @track = Track.find(params[:id])
   return true if user_is_track_manager?(@track) && @track.site_id == current_user.site_id
   flash[:error] = "Not Authorized as Track Manager"
   redirect_to(message_path)
  end

  def check_for_number_tracks
    return true if current_user.has_role? :admin
    count = Track.where(:owner_id => current_user.id).count
    if count > @site.max_tracks
     flash[:notice] = "Sorry you can only own #{@site.max_tracks} tracks at this time."
     redirect_to(message_path)
    end
  end
end
