puts "🌱 Seeding CEU Events..."

events_data = [
  {
    title: "Advanced Cardiac Life Support (ACLS) Renewal",
    provider: "American Heart Association",
    event_type: "In-Person",
    category: "Nursing",
    credits: 8.0,
    date: 2.weeks.from_now,
    location: "Miami, FL",
    url: "https://cpr.heart.org",
    description: "One-day renewal course for ACLS certification."
  },
  {
    title: "Ethics in Modern Healthcare",
    provider: "HealthStream",
    event_type: "Online",
    category: "Ethics",
    credits: 2.0,
    date: 3.days.from_now,
    location: "Remote",
    url: "https://www.healthstream.com",
    description: "Webinar covering bioethics and patient rights."
  },
  {
    title: "National Nursing Symposium 2025",
    provider: "ANA",
    event_type: "Conference",
    category: "Leadership",
    credits: 15.0,
    date: 2.months.from_now,
    location: "Orlando, FL",
    url: "https://www.nursingworld.org",
    description: "3-day conference on the future of nursing leadership."
  },
  {
    title: "Pediatric Trauma Updates",
    provider: "Children's Hospital",
    event_type: "Seminar",
    category: "Pediatrics",
    credits: 4.0,
    date: 1.month.from_now,
    location: "Tampa, FL",
    url: nil,
    description: "Latest protocols for pediatric trauma care."
  }
]

# Idempotent creation (safe to run multiple times)
events_data.each do |data|
  CeuEvent.find_or_create_by!(title: data[:title]) do |event|
    event.assign_attributes(data)
  end
end

puts "✅ CEU Events Seeded. Total count: #{CeuEvent.count}"