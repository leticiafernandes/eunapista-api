class EventsController < ApplicationController
	skip_before_action :verify_authenticity_token, raise: false
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.order(created_at: :desc)
  end

  def find_by_date
    @events = Event.where(start_date: params[:start_date]+' 00:00:00')

    if !@events.nil?
      render json: @events,  status:  :ok
    else
      render json: @events.errors, status: :unprocessable_entity
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def get_local(id)
    @local = Local.find(id)
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    start_local = Local.where(["place_id = :param", { param: start_local_params["place_id"] }]).first
    if not start_local
      start_local = Local.new(start_local_params)
      start_local.save
    end

    finish_local = Local.where(["place_id = :param", { param: finish_local_params["place_id"] }]).first
    if not finish_local
      finish_local = Local.new(finish_local_params)
      finish_local.save
    end

    @event.start_local_id = start_local.id
    @event.finish_local_id = finish_local.id

      if @event.save
        render json: @event
      else
        render json: @event.errors
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
    @event.destroy
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params
        .require(:event)
        .permit(
          :name, 
          :start_date, 
          :race_time,  
          :value, 
          :link
        )
    end

    def start_local_params
      params
        .require(:start_local)
        .permit(
          :place_id,
          :local_text,
          :comp_text,
          :lat,
          :lng
        )
    end

    def finish_local_params
      params
        .require(:finish_local)
        .permit(
          :place_id,
          :local_text,
          :comp_text,
          :lat,
          :lng
        )
    end
end
