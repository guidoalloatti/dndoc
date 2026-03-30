class PartyRewardEngine
  REWARD_MULTIPLIERS = {
    "low"       => 0.3,
    "medium"    => 0.6,
    "high"      => 0.85,
    "very_high" => 1.0,
  }.freeze

  REWARD_LEVELS = REWARD_MULTIPLIERS.keys.freeze

  # Race → preferred category names (combined with class affinities)
  RACE_CATEGORY_PREFERENCES = {
    "Human"      => [],
    "Elf"        => %w[Scrolls Staffs Wands Rings Cloaks Ammunition],
    "Dwarf"      => %w[Armor Shields Weapons Helms Gems],
    "Halfling"   => %w[Weapons Rings Boots Trinkets],
    "Half-Elf"   => %w[Rings Amulets Cloaks Scrolls],
    "Half-Orc"   => %w[Weapons Armor Helms],
    "Gnome"      => %w[Books Wands Trinkets Gems Scrolls],
    "Tiefling"   => %w[Amulets Rings Staffs Potions],
    "Dragonborn" => %w[Weapons Armor Shields Helms],
    "Aasimar"    => %w[Amulets Scrolls Rings Cloaks],
    "Tabaxi"     => %w[Boots Weapons Trinkets Cloaks],
    "Genasi"     => %w[Potions Gems Rings Bracelet],
    "Goliath"    => %w[Weapons Armor Shields Helms],
    "Warforged"  => %w[Armor Shields Weapons],
  }.freeze

  RACES = RACE_CATEGORY_PREFERENCES.keys.freeze

  # Calculate item power from character level (1-20) and reward level
  def self.calculate_power(level, reward_level)
    base_power = (level / 20.0 * 10).ceil
    multiplier = REWARD_MULTIPLIERS.fetch(reward_level, 0.6)
    (base_power * multiplier).round.clamp(1, 10)
  end

  # Select a category appropriate for the character class and optionally race
  def self.select_category(character_class, race = nil)
    weighted_ids = character_class.weighted_category_ids.dup

    # Add race preferences (weight 1 each) to class affinities
    if race.present? && RACE_CATEGORY_PREFERENCES.key?(race)
      race_names = RACE_CATEGORY_PREFERENCES[race]
      if race_names.any?
        race_category_ids = Category.where(name: race_names).pluck(:id)
        weighted_ids.concat(race_category_ids)
      end
    end

    if weighted_ids.any?
      Category.find(weighted_ids.sample)
    else
      Category.order("RANDOM()").first
    end
  end

  # Generate reward items for an entire party (returns hashes, not saved records)
  def self.generate_party_rewards(party_members, items_per_member = 1, lore: "faerun")
    party_members.map do |member|
      char_class = CharacterClass.find(member[:character_class_id])
      race = member[:race].presence
      items = items_per_member.times.map do
        build_reward_item(char_class, member[:level].to_i, member[:reward_level], race, lore: lore)
      end

      {
        name: member[:name].presence || char_class.name,
        character_class: char_class.name,
        race: race,
        level: member[:level].to_i,
        reward_level: member[:reward_level],
        character_id: member[:character_id].presence,
        items: items,
      }
    end
  end

  # Generate a single reward item (returns a hash, not saved)
  def self.build_reward_item(character_class, level, reward_level, race = nil, lore: "faerun")
    power = calculate_power(level, reward_level)
    category = select_category(character_class, race)
    rarity_name = rarity_name_for_power(power)
    rarity = Rarity.find_by(name: rarity_name)

    # Build effects using existing ItemEngine logic
    effects = select_effects(power, category)
    actual_power = effects.sum(&:power_level)

    # Recalculate rarity based on actual effects assigned
    rarity_name = rarity_name_for_power(actual_power)
    rarity = Rarity.find_by(name: rarity_name)

    weapon_name = nil
    if category.name == "Weapons"
      weapon_name = Weapon.order("RANDOM()").first&.name
    end

    name = ItemEngine.generate_name(rarity_name, effects, category, weapon_name, lore: lore)
    description = ItemEngine.generate_description(rarity_name, effects, category, weapon_name, lore: lore)

    {
      name: name,
      description: description,
      item_type: category.name,
      power: actual_power,
      weight: rand(category.min_weight..category.max_weight),
      price: rand(rarity.min_price..rarity.max_price),
      requires_attunement: actual_power > 2,
      category_id: category.id,
      category_name: category.name,
      rarity_id: rarity.id,
      rarity_name: rarity_name,
      weapon_name: weapon_name,
      effects: effects.map { |e|
        { id: e.id, name: e.translated_name, effect_type: e.effect_type, power_level: e.power_level, description: e.translated_description }
      },
    }
  end

  private

  def self.select_effects(target_power, category)
    available_power = target_power
    selected_effects = []
    selected_types = []

    # For weapons, prioritize attack effects
    if category.name == "Weapons"
      effect = find_attack_effect(available_power, category, "Attack Bonus")
      if effect
        selected_effects << effect
        available_power -= effect.power_level
        selected_types << effect.effect_type
      end

      if available_power > 0
        effect = find_attack_effect(available_power, category, "Attack Damage")
        if effect
          selected_effects << effect
          available_power -= effect.power_level
          selected_types << effect.effect_type
        end
      end
    end

    # Fill remaining power with recommended effects
    attempts = 0
    while available_power > 0 && attempts < 20
      attempts += 1
      recommendations = ItemEngine.recommend_effects(category, selected_types, available_power)
      best = recommendations.first
      break unless best

      effect = best[:effect]
      selected_effects << effect
      available_power -= effect.power_level
      selected_types << effect.effect_type
    end

    selected_effects
  end

  def self.find_attack_effect(power, category, effect_type)
    min_power, max_power = case power
                            when 5..10 then [2, 5]
                            when 4 then [1, 4]
                            when 3 then [0, 3]
                            when 2 then [0, 2]
                            else [0, 1]
                            end

    Effect.joins(:categories)
          .where(categories: { id: category.id })
          .where(effect_type: effect_type)
          .where(power_level: min_power..max_power)
          .sample
  end

  def self.rarity_name_for_power(power)
    case power
    when 0..1 then "Common"
    when 2..3 then "Uncommon"
    when 4..5 then "Rare"
    when 6..7 then "Very Rare"
    when 8..9 then "Legendary"
    when 10   then "Ancestral"
    else "Common"
    end
  end
end
