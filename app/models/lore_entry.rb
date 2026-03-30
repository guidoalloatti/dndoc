class LoreEntry < ApplicationRecord
  validates :lore_type, presence: true, inclusion: { in: %w[faerun middle_earth] }
  validates :category, presence: true
  validates :value, presence: true

  LORE_TYPES = %w[faerun middle_earth].freeze

  CATEGORIES = %w[
    prefix category_title suffix simple_suffix
    smith wielder place event deity organization material age
    origin effect_description effect_flavor
    curse prophecy personality_trait dramatic_closing
    effect_transition historical_anecdote
  ].freeze

  # Categories that require a key (grouped by rarity, effect_type, or category name)
  KEYED_CATEGORIES = %w[prefix category_title origin effect_description effect_flavor].freeze

  scope :for_lore, ->(lore_type) { where(lore_type: lore_type) }
  scope :for_category, ->(category) { where(category: category) }
  scope :for_key, ->(key) { where(key: key) }

  # Fetch random value(s) for a given lore/category/key combo — cached per request
  def self.sample(lore_type, category, key = nil)
    entries = fetch_values(lore_type, category, key)
    entries.sample
  end

  def self.sample_many(lore_type, category, key = nil, count: 1)
    entries = fetch_values(lore_type, category, key)
    entries.sample(count)
  end

  def self.all_values(lore_type, category, key = nil)
    fetch_values(lore_type, category, key)
  end

  private

  def self.fetch_values(lore_type, category, key = nil)
    cache_key = "#{lore_type}/#{category}/#{key}"
    @_cache ||= {}
    @_cache[cache_key] ||= begin
      scope = where(lore_type: lore_type, category: category)
      scope = scope.where(key: key) if key
      scope.pluck(:value)
    end
  end

  def self.clear_cache!
    @_cache = {}
  end
end
