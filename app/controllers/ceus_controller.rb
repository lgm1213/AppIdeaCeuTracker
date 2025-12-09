class CeusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ceu, only: [:edit, :update, :destroy]


  def new
    @ceu = Ceu.new

    # Checks if we are importing data from a Saved Event
    if params[:import_event_id].present?
      event = CeuEvent.find(params[:import_event_id])
      
      # Pre-fill the form data
      @ceu.title = event.title
      @ceu.duration = event.credits
      @ceu.date = event.date
      
      # Stores the ID of the saved_event record so we can delete it after saving
      @remove_saved_id = params[:saved_event_id]
    end
  end

  def create
    @ceu = current_user.ceus.build(ceu_params)

    if @ceu.save
      # Cleans up the SavedEvent if this came from the "Mark as Complete" workflow
      if params[:remove_saved_id].present?
        saved_record = current_user.saved_events.find_by(id: params[:remove_saved_id])
        saved_record&.destroy
      end

      redirect_to dashboard_path, notice: "CEU logged successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @ceu.update(ceu_params)
      redirect_to dashboard_path, notice: "CEU updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ceu.destroy
    redirect_to dashboard_path, notice: "CEU removed."
  end

  private

  def set_ceu
    @ceu = current_user.ceus.find(params[:id])
  end

  def ceu_params
    params.require(:ceu).permit(:title, :date, :duration, :certificate)
  end
end
