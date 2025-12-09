class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    # all upcoming events (sorted by date)
    @events = CeuEvent.upcoming

    # Apply filters if the user provided them
    @events = @events.search_text(params[:query])        if params[:query].present?
    @events = @events.by_type(params[:event_type])       if params[:event_type].present?
    @events = @events.by_category(params[:category])     if params[:category].present?
    @events = @events.search_location(params[:location]) if params[:location].present?

    # 3. Dropdown Data
    # Fetch unique types/categories from DB to populate the <select> options
    @types = CeuEvent.distinct.pluck(:event_type).compact.sort
    @categories = CeuEvent.distinct.pluck(:category).compact.sort
  end

  def show
    @event = CeuEvent.find(params[:id])
  end
end
