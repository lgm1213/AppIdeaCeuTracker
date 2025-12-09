class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Check if the user has submitted any filter parameters
    has_search = params[:query].present? || 
                 params[:event_type].present? || 
                 params[:category].present? || 
                 params[:location].present?

    if has_search
      # 1. Start with all upcoming events
      @events = CeuEvent.upcoming

      # 2. Apply filters
      @events = @events.search_text(params[:query])       if params[:query].present?
      @events = @events.by_type(params[:event_type])      if params[:event_type].present?
      @events = @events.by_category(params[:category])    if params[:category].present?
      @events = @events.search_location(params[:location]) if params[:location].present?
    else
      # 3. No search yet? Return empty list (Blank slate)
      @events = CeuEvent.none
    end

    # Dropdown data is needed even for the empty state
    @types = CeuEvent.distinct.pluck(:event_type).compact.sort
    @categories = CeuEvent.distinct.pluck(:category).compact.sort
  end

  def show
    @event = CeuEvent.find(params[:id])
  end
end