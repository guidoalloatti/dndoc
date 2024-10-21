class Weapon < ApplicationRecord
  validates :name, presence: true
  validates :cost, :weight, numericality: { greater_than_or_equal_to: 0 }
  validates :damage, presence: true
end