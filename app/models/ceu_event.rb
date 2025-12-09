class CeuEvent < ApplicationRecord
  # --- Validations ---
  validates :title, presence: true
  validates :date, presence: true
  validates :credits, numericality: { greater_than: 0 }

  # --- Scopes (Search Filters) ---

  # Only show future events, sorted by soonest first
  scope :upcoming, -> { where("date >= ?", Time.current).order(date: :asc) }

  # Filter by dropdowns
  scope :by_type, ->(type) { where(event_type: type) if type.present? }
  scope :by_category, ->(category) { where(category: category) if category.present? }

  # Text Search (Case insensitive)
  # NOTE: If using SQLite, 'LIKE' is fine. If using PostgreSQL in production, 'ILIKE' is better.
  scope :search_text, ->(query) {
    where("title LIKE ? OR provider LIKE ?", "%#{query}%", "%#{query}%") if query.present?
  }

  scope :search_location, ->(loc) {
    where("location LIKE ?", "%#{loc}%") if loc.present?
  }
end
