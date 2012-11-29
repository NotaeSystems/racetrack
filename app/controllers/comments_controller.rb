class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new
    if params[:race_id]
      @race = Race.find(params[:race_id])
      @card = @race.card
      @meet = @card.meet
      @track = @meet.track
    elsif params[:card_id]
      logger.debug "card id is #{params[:card_id]}"
      @card = Card.find(params[:card_id])
      @comment.card_id =@card.id
      @meet = @card.meet
    end
      @comment.meet_id = @meet.id
      @track = @meet.track
      @comment.user_id = current_user.id
    #redirect_to card_path(:id => @card.id)
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @track = @comment.track
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @card = @comment.card
    respond_to do |format|
      if @comment.save
        if @comment.race
          format.html { redirect_to race_path(:id => @comment.race_id), notice: 'Comment was successfully updated.' }
        elsif @comment.card
          format.html { redirect_to @card, notice: 'Comment was successfully updated.' }
        elsif @comment.meet
        format.html { redirect_to @card, notice: 'Comment was successfully updated.' }
        else
          format.html { redirect_to @track, notice: 'Comment was successfully updated.' }
          format.json { render json: @card, status: :created, location: @card }
        end


      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        if @comment.race
          format.html { redirect_to race_path(:id => @comment.race_id), notice: 'Comment was successfully updated.' }
        elsif @comment.card
          format.html { redirect_to @card, notice: 'Comment was successfully updated.' }
        elsif @comment.meet
        format.html { redirect_to @card, notice: 'Comment was successfully updated.' }
        else
          format.html { redirect_to @track, notice: 'Comment was successfully updated.' }
          format.json { render json: @card, status: :created, location: @card }
        end


      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @card = @comment.card
    @comment.destroy
    respond_to do |format|

        if @comment.race
          format.html { redirect_to race_path(:id => @comment.race_id), notice: 'Comment was successfully deleted.' }
        elsif @comment.card
          format.html { redirect_to @card, notice: 'Comment was successfully deleted.' }
        elsif @comment.meet
        format.html { redirect_to @card, notice: 'Comment was successfully deleted.' }
        else
          format.html { redirect_to @track, notice: 'Comment was successfully deleted.' }
          format.json { render json: @card, status: :created, location: @card }
        end


 
    end 
  end
end
