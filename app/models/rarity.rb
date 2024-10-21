class Rarity < ApplicationRecord
  has_many :items

  validates :name, presence: true, uniqueness: true
  validates :min_price, :max_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :min_price_less_than_max_price

  private

  def min_price_less_than_max_price
    if min_price.present? && max_price.present? && min_price > max_price
      errors.add(:min_price, "must be less than or equal to max price")
    end
  end
end
	