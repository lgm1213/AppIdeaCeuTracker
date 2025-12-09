class CeuEvent < ApplicationRecord
  # --- Validations ---
  validates :title, presence: true
  validates :date, presence: true
  validates :credits, numericality: { greater_than: 0 }

  # --- Scopes (Search Filters) ---
  
  # Only show future events, sorted by soonest first
  scope :upcoming, -> { where("date >= ?", Time.current).order(date: :asc) }
  
  # Filter by dropdowns (Checks if value is present before filtering)
  scope :by_type, ->(type) { where(event_type: type) if type.present? }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  
  # Text Search (Improved)
  # 1. Searches Title, Provider, AND Description
  # 2. Uses LOWER() to ensure case-insensitive matching on all databases (SQLite/Postgres)
  scope :search_text, ->(query) { 
    return all if query.blank?
    
    term = "%#{query.downcase}%"
    where(
      "LOWER(title) LIKE ? OR LOWER(provider) LIKE ? OR LOWER(description) LIKE ?", 
      term, term, term
    )
  }
  
  scope :search_location, ->(loc) { 
    return all if loc.blank?
    where("LOWER(location) LIKE ?", "%#{loc.downcase}%") 
  }
end