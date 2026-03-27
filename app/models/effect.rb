class Effect < ApplicationRecord
  # belongs_to :item
  has_many :item_effects
  has_many :items, through: :item_effects
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :effect_type, presence: true
  validates :power_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :search_by_name, ->(query) { where("effects.name ILIKE ?", "%#{query}%") if query.present? }
  scope :by_effect_type, ->(type) { where(effect_type: type) if type.present? }
  scope :by_power_level, ->(level) { where(power_level: level) if level.present? }

  scope :sorted, ->(col, dir) {
    dir = "asc" unless %w[asc desc].include?(dir)
    case col
    when "name", "effect_type", "power_level" then order(col => dir)
    else order(name: :asc)
    end
  }
end
