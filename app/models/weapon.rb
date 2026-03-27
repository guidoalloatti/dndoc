class Weapon < ApplicationRecord
  validates :name, presence: true
  validates :cost, :weight, numericality: { greater_than_or_equal_to: 0 }
  validates :damage, presence: true

  scope :search_by_name, ->(query) { where("weapons.name ILIKE ?", "%#{query}%") if query.present? }
  scope :by_damage, ->(dmg) { where(damage: dmg) if dmg.present? }

  scope :sorted, ->(col, dir) {
    dir = "asc" unless %w[asc desc].include?(dir)
    case col
    when "name", "cost", "damage", "weight" then order(col => dir)
    else order(name: :asc)
    end
  }
end