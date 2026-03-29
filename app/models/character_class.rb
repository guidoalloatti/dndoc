class CharacterClass < ApplicationRecord
  has_many :class_category_affinities, dependent: :destroy
  has_many :categories, through: :class_category_affinities

  validates :name, presence: true, uniqueness: true

  scope :search_by_name, ->(query) { where("character_classes.name ILIKE ?", "%#{query}%") if query.present? }

  scope :sorted, ->(col, dir) {
    dir = "asc" unless %w[asc desc].include?(dir)
    case col
    when "name" then order(col => dir)
    else order(name: :asc)
    end
  }

  # Returns a weighted array of category IDs for random selection
  # Higher-affinity categories appear more times, making them more likely to be picked
  def weighted_category_ids
    class_category_affinities.includes(:category).flat_map do |aff|
      [aff.category_id] * aff.weight
    end
  end
end
