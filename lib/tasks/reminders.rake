namespace :reminders do
  desc "Check for licenses expiring in 30 days and send email alerts"
  task check_expiring: :environment do
    # 1. Define the target date (30 days from now)
    target_date = 30.days.from_now.to_date
    
    puts "🔍 Checking for licenses expiring on #{target_date}..."

    # 2. Find licenses matching that date
    expiring_licenses = ProfessionalLicense.where(expiration_date: target_date)

    if expiring_licenses.empty?
      puts "✅ No licenses found expiring on this date."
    else
      puts "⚠️  Found #{expiring_licenses.count} licenses expiring soon. Sending emails..."
      
      # 3. Loop through and send emails
      expiring_licenses.each do |license|
        user = license.user
        
        if user.present?
          LicenseMailer.with(user: user, license: license).expiring_soon.deliver_now
          puts "   -> Email sent to #{user.email_address} for license #{license.license_number}"
        else
          puts "   -> Skipping license #{license.license_number} (No user attached)"
        end
      end
    end
    
    puts "Done."
  end
end