class Item < ApplicationRecord
  belongs_to :category
  belongs_to :rarity
  has_many :item_effects
  has_many :effects, through: :item_effects

  validates :name, presence: true
  validates :item_type, presence: true
end
