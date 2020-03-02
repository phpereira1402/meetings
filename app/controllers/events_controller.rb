class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /events
  # GET /events.json
  def index

    if (params[:start] != nil && params[:end] != nil)
      start_date = params[:start].to_s
      end_date = params[:end].to_s
      @events = Event.where(start: params[:start]..params[:end]).to_a    
    else
      @events = Event.find([1,2])
    end

    # @events.each do |e|
    #   e.isReadOnly = current_user.id == e.user_id
    #   e.calendarId = 0     
    #   p e
    # end
    
    respond_to do |format|
      format.html # index.html.erb      
      format.json { render json: @events }
    end
    
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.user_id = current_user.id
    @event.description = @event.location
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    
    @event = Event.new(event_params)
    
    @event.user_id = current_user.id    
    
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])

    if @event.user_id == current_user.id
      @event.destroy
    end

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      #logger.debug "New #{params}"
      params.require(:event).permit(:title, :description, :start, :end, :state, :isAllDay)
      #params.require(:event).permit(:title, :description, :start, :end, :user_id, :state, :isAllDay)
    end
end
