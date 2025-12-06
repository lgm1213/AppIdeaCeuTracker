class CeusController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @ceu = Ceu.new
  end

  def create
    @ceu = current_user.ceus.build(ceu_params)

    if @ceu.save
      redirect_to dashboard_path, notice: "CEU record added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @ceu = current_user.ceus.find(params[:id])
    @ceu.destroy
    redirect_to dashboard_path, notice: "CEU removed."
  end

  private

  def ceu_params
    params.require(:ceu).permit(:title, :date, :duration, :certificate)
  end
end
