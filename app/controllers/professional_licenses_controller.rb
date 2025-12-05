class ProfessionalLicensesController < ApplicationController
  before_action :authenticate_user!

  def new
    @license = ProfessionalLicense.new
    # Fetch all authorities for the dropdown menu
    @authorities = IssuingAuthority.order(:name)
  end

  def create
    @license = current_user.professional_licenses.build(license_params)
    
    if @license.save
      redirect_to dashboard_path, notice: "License added successfully!"
    else
      # If it fails (e.g. wrong format), reload the form with errors
      @authorities = IssuingAuthority.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @license = current_user.professional_licenses.find(params[:id])
    @license.destroy
    redirect_to dashboard_path, notice: "License removed."
  end

  private

  def license_params
    params.require(:professional_license).permit(
      :issuing_authority_id, 
      :license_number, 
      :expiration_date
    )
  end
end
