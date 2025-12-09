class SavedEventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @saved_events = current_user.saved_ceu_events
  end

  def create
    # Find the CEU event based on the ID passed from the button
    @event = CeuEvent.find(params[:ceu_event_id])
    
    # Create the link between the current user and the event
    current_user.saved_events.create(ceu_event: @event)
    
    # Redirect back to wherever the user clicked the button (Search page or Dashboard)
    redirect_back(fallback_location: events_path, notice: "Event saved for later.")
  end

  

  def destroy
    # Find the specific saved record (not the CEU event itself, but the connection)
    @saved_event = current_user.saved_events.find(params[:id])
    @saved_event.destroy
    
    redirect_back(fallback_location: events_path, notice: "Event removed from saved list.")
  end
end