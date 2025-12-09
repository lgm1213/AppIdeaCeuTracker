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

# db/seeds.rb
# This file automatically loads any script found in db/seeds/*.rb

puts "🚀 Starting Database Seed..."

# Iterate through every .rb file in db/seeds/ and load it
Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |seed|
  filename = File.basename(seed)
  puts "   -> Loading: #{filename}"
  load seed
end

puts "🏁 All seeds loaded successfully."
