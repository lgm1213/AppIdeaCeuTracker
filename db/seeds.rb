# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# This file populates the database with default values.
# Run 'bin/rails db:seed' to load this data.

puts "Seeding Issuing Authorities..."

# Create some sample boards with Regex validation rules
IssuingAuthority.find_or_create_by!(name: "Florida Board of Nursing") do |auth|
  auth.state = "FL"
  # Rule: Starts with RN, followed by 7 digits (e.g., RN1234567)
  auth.license_format_regex = "^RN[0-9]{7}$"
end

IssuingAuthority.find_or_create_by!(name: "California Board of Registered Nursing") do |auth|
  auth.state = "CA"
  # Rule: Just digits, usually 6 to 8 long
  auth.license_format_regex = "^[0-9]{6,8}$"
end

IssuingAuthority.find_or_create_by!(name: "Generic Certification Board") do |auth|
  auth.state = "National"
  # No regex means any format is accepted
  auth.license_format_regex = nil
end

puts "Done! Created #{IssuingAuthority.count} authorities."