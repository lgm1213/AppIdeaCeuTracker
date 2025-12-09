class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Start with all upcoming events
    # We load them lazily (ActiveRecord doesn't query DB yet)
    @events = CeuEvent.upcoming

    # Checks if the user is trying to search/filter
    # We check if any param is present AND not an empty string
    has_search = params[:query].present? || 
                 params[:event_type].present? || 
                 params[:category].present? || 
                 params[:location].present?

    if has_search
      # Apply the filters chain
      # The scopes in the model now handle blank values safely, 
      # we call them here conditionally for clarity.
      @events = @events.search_text(params[:query])       if params[:query].present?
      @events = @events.by_type(params[:event_type])      if params[:event_type].present?
      @events = @events.by_category(params[:category])    if params[:category].present?
      @events = @events.search_location(params[:location]) if params[:location].present?
    else
      # Show nothing (Blank Slate) if no search performed
      # To show ALL events by default, change this line to: @events = @events
      @events = CeuEvent.none
    end

    # Dropdown Data is Always needed for the search form
    @types = CeuEvent.distinct.pluck(:event_type).compact.sort
    @categories = CeuEvent.distinct.pluck(:category).compact.sort
  end

  def show
    @event = CeuEvent.find(params[:id])
  end
end