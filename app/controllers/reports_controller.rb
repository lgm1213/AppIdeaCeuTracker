require 'csv'
require 'prawn'
require 'prawn/table'

class ReportsController < ApplicationController
  before_action :authenticate_user!

  def export
    @ceus = current_user.ceus.order(date: :desc)
    @licenses = current_user.professional_licenses

    respond_to do |format|
      format.csv { send_data generate_csv, filename: "ceu-report-#{Date.today}.csv" }
      format.pdf { send_data generate_pdf, filename: "ceu-report-#{Date.today}.pdf", type: "application/pdf", disposition: "inline" }
    end
  end

  private

  def generate_csv
    CSV.generate(headers: true) do |csv|
      # Add Summary Section
      csv << ["CEU TRACKING REPORT"]
      csv << ["Generated on", Date.today.strftime("%B %d, %Y")]
      csv << ["User", current_user.profile&.full_name || current_user.email_address]
      csv << [] # Blank line

      # Add Licenses Section
      csv << ["ACTIVE LICENSES"]
      csv << ["Authority", "License Number", "Expiration", "Status"]
      @licenses.each do |license|
        csv << [
          license.issuing_authority.name,
          license.license_number,
          license.expiration_date,
          license.status_label
        ]
      end
      csv << [] # Blank line

      # Add CEUs Section
      csv << ["CEU HISTORY"]
      csv << ["Date", "Title", "Credits", "Certificate?"]
      @ceus.each do |ceu|
        csv << [
          ceu.date,
          ceu.title,
          ceu.duration,
          ceu.certificate.attached? ? "Yes" : "No"
        ]
      end
    end
  end

  def generate_pdf
    Prawn::Document.new do |pdf|
      # Header
      pdf.font_size 20
      pdf.text "Professional Development Report", style: :bold
      pdf.font_size 12
      pdf.text "Generated on: #{Date.today.strftime('%B %d, %Y')}"
      pdf.text "User: #{current_user.profile&.full_name}"
      pdf.move_down 20

      # Licenses Table
      pdf.font_size 16
      pdf.text "Active Licenses", style: :bold
      pdf.move_down 10
      
      if @licenses.any?
        license_data = [["Authority", "License #", "Expires", "Status"]] + 
                       @licenses.map { |l| [l.issuing_authority.name, l.license_number, l.expiration_date.to_s, l.status_label] }
        
        pdf.table(license_data, header: true, width: pdf.bounds.width) do
          row(0).style(font_style: :bold, background_color: "EEEEEE")
          cells.padding = 8
          cells.borders = [:bottom]
        end
      else
        pdf.text "No licenses recorded.", style: :italic
      end
      
      pdf.move_down 30

      # CEUs Table
      pdf.font_size 16
      pdf.text "CEU History", style: :bold
      pdf.move_down 10

      if @ceus.any?
        ceu_data = [["Date", "Activity Title", "Credits"]] + 
                   @ceus.map { |c| [c.date.strftime("%b %d, %Y"), c.title, c.duration.to_s] }
        
        pdf.table(ceu_data, header: true, width: pdf.bounds.width) do
          row(0).style(font_style: :bold, background_color: "EEEEEE")
          column(0).width = 100
          column(2).width = 60
          cells.padding = 8
          cells.borders = [:bottom]
        end

        pdf.move_down 20
        pdf.font_size 12
        pdf.text "Total Credits: #{@ceus.sum(:duration)}", style: :bold, align: :right
      else
        pdf.text "No CEUs recorded yet.", style: :italic
      end
    end.render
  end
end