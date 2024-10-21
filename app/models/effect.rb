class Effect < ApplicationRecord
  # belongs_to :item
  has_many :item_effects
  has_many :items, through: :item_effects
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :effect_type, presence: true
  validates :power_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
