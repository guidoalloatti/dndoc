class Item < ApplicationRecord
  ORIGINS = %w[Divino Elfico Enano Humano Desconocido].freeze

  has_one_attached :image

  belongs_to :category
  belongs_to :rarity
  belongs_to :user, optional: true
  belongs_to :character, optional: true
  has_many :item_effects
  has_many :effects, through: :item_effects

  validates :name, presence: true
  validates :item_type, presence: true
  validates :power, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :origin, inclusion: { in: ORIGINS }, allow_nil: true

  scope :search_by_name, ->(query) { where("items.name ILIKE ?", "%#{query}%") if query.present? }
  scope :by_category, ->(id) { where(category_id: id) if id.present? }
  scope :by_rarity, ->(id) { where(rarity_id: id) if id.present? }
  scope :by_attunement, ->(val) { where(requires_attunement: val == "true") if val.present? }
  scope :sorted, ->(col, dir) {
    dir = "asc" unless %w[asc desc].include?(dir)
    case col
    when "category"
      joins(:category).order("categories.name #{dir}")
    when "rarity"
      joins(:rarity).order("rarities.name #{dir}")
    when "name", "power", "price", "weight"
      order(col => dir)
    else
      order(name: :asc)
    end
  }
end
