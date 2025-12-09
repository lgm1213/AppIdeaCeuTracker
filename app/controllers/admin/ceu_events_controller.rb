module Admin
  class CeuEventsController < BaseController
    before_action :set_event, only: [:edit, :update, :destroy]

    def index
      @events = CeuEvent.order(date: :desc)
    end

    def new
      @event = CeuEvent.new
    end

    def create
      @event = CeuEvent.new(event_params)
      if @event.save
        redirect_to admin_ceu_events_path, notice: "Event created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @event.update(event_params)
        redirect_to admin_ceu_events_path, notice: "Event updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to admin_ceu_events_path, notice: "Event deleted."
    end

    private

    def set_event
      @event = CeuEvent.find(params[:id])
    end

    def event_params
      params.require(:ceu_event).permit(:title, :provider, :event_type, :category, :credits, :date, :location, :url, :description)
    end
  end
end