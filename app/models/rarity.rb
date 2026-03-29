class Rarity < ApplicationRecord
  has_many :items

  validates :name, presence: true, uniqueness: true
  validates :min_price, :max_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :min_power, :max_power, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validate :min_price_less_than_max_price
  validate :min_power_less_than_max_power

  scope :search_by_name, ->(query) { where("rarities.name ILIKE ?", "%#{query}%") if query.present? }

  scope :sorted, ->(col, dir) {
    dir = "asc" unless %w[asc desc].include?(dir)
    case col
    when "name", "min_price", "max_price", "min_power", "max_power" then order(col => dir)
    else order(name: :asc)
    end
  }

  private

  def min_price_less_than_max_price
    if min_price.present? && max_price.present? && min_price > max_price
      errors.add(:min_price, "must be less than or equal to max price")
    end
  end

  def min_power_less_than_max_power
    if min_power.present? && max_power.present? && min_power > max_power
      errors.add(:min_power, "must be less than or equal to max power")
    end
  end
end
	