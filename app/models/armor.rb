class Armor < ApplicationRecord
  TYPES = %w[Light Medium Heavy Shield].freeze

  validates :name, presence: true
  validates :armor_type, presence: true, inclusion: { in: TYPES }
  validates :armor_class, presence: true
  validates :cost, :weight, numericality: { greater_than_or_equal_to: 0 }

  scope :search_by_name, ->(query) { where("armors.name ILIKE ?", "%#{query}%") if query.present? }
  scope :by_type, ->(type) { where(armor_type: type) if type.present? }

  scope :sorted, ->(col, dir) {
    dir = "asc" unless %w[asc desc].include?(dir)
    case col
    when "name", "cost", "weight", "armor_type" then order(col => dir)
    else order(armor_type: :asc, name: :asc)
    end
  }
end
