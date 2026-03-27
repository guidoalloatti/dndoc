class Category < ApplicationRecord
  has_many :items, dependent: :destroy
  has_and_belongs_to_many :effects

  validates :name, presence: true

  scope :search_by_name, ->(query) { where("categories.name ILIKE ?", "%#{query}%") if query.present? }

  scope :sorted, ->(col, dir) {
    dir = "asc" unless %w[asc desc].include?(dir)
    case col
    when "name", "min_weight", "max_weight" then order(col => dir)
    else order(name: :asc)
    end
  }
end
