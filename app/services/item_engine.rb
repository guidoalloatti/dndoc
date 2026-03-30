class ItemEngine
  # ══════════════════════════════════════════════════════
  # EFFECT SYNERGIES — effects that combine well together
  # ══════════════════════════════════════════════════════
  SYNERGIES = {
    "Attack Bonus"    => ["Attack Damage", "Material", "Precision", "Speed", "Initiative"],
    "Attack Damage"   => ["Attack Bonus", "Frosting", "Lightning", "Paralyzing"],
    "Defense"         => ["Resistance", "Protection", "Durability", "Healing"],
    "Healing"         => ["Protection", "Restoration", "Defense", "Resistance"],
    "Material"        => ["Attack Bonus", "Durability", "Sharpness", "Attack Damage"],
    "Stealth"         => ["Speed", "Seeing", "Sense", "Vision", "Detection"],
    "Conjuration"     => ["Summoning", "Control", "Minding"],
    "Speed"           => ["Initiative", "Movement", "Jumping", "Flight"],
    "Protection"      => ["Defense", "Resistance", "Durability", "Inmunity"],
    "Resistance"      => ["Protection", "Defense", "Inmunity", "Saving Throws"],
    "Flight"          => ["Speed", "Movement", "Climbing"],
    "Vision"          => ["Detection", "Seeing", "Sense", "Sight"],
    "Frosting"        => ["Attack Damage", "Paralyzing", "Speed"],
    "Lightning"       => ["Attack Damage", "Paralyzing", "Stunning"],
    "Summoning"       => ["Conjuration", "Control", "Minding"],
    "Luck"            => ["Protection", "Attack Bonus", "Healing"],
    "Control"         => ["Conjuration", "Summoning", "Minding", "Frosting"],
    "Minding"         => ["Control", "Vision", "Detection", "Summoning"],
    "Enhance"         => ["Healing", "Protection", "Speed", "Initiative"],
    "Understanding"   => ["Minding", "Vision", "Detection"],
    "Utility"         => ["Healing", "Protection", "Stealth"],
    "Absortion"       => ["Protection", "Resistance", "Minding"],
  }.freeze

  # Effects that conflict (shouldn't be combined)
  CONFLICTS = {
    "Stealth"    => ["Glow", "Loudness", "Lightning"],
    "Glow"       => ["Stealth"],
    "Loudness"   => ["Stealth"],
    "Flight"     => ["Climbing"],
    "Climbing"   => ["Flight"],
    "Frosting"   => ["Lightning"],
    "Lightning"  => ["Frosting", "Stealth"],
  }.freeze

  # ══════════════════════════════════════════════════════
  # LORE DATA ACCESS — reads from lore_entries table
  # ══════════════════════════════════════════════════════

  def self.lore(lore_type, category, key = nil)
    LoreEntry.all_values(lore_type, category, key)
  end

  def self.lore_sample(lore_type, category, key = nil)
    LoreEntry.sample(lore_type, category, key)
  end

  # ══════════════════════════════════════════════════════
  # NAME GENERATION
  # ══════════════════════════════════════════════════════

  def self.generate_name(rarity_name, effects, category, weapon = nil, lore: "faerun")
    lt = lore.to_s

    prefixes = lore(lt, "prefix", rarity_name)
    prefixes = lore(lt, "prefix", "Common") if prefixes.empty?
    prefix = prefixes.sample

    # Category-based title
    cat_name = category.name
    if (cat_name == "Weapons" || cat_name == "Armor" || cat_name == "Shields") && weapon.present?
      base = weapon
    else
      titles = lore(lt, "category_title", cat_name)
      base = titles.any? ? titles.sample : cat_name.singularize
    end

    # Effect-based flavor (shared across lores from DB)
    primary_effect = effects.max_by(&:power_level) if effects.any?
    flavor = nil
    if primary_effect
      flavors = lore(lt, "effect_flavor", primary_effect.effect_type)
      flavor = flavors.sample if flavors.any?
    end

    # Suffix based on rarity
    suffix = case rarity_name
             when "Legendary", "Ancestral"
               lore_sample(lt, "suffix")
             when "Very Rare", "Rare"
               rand < 0.6 ? lore_sample(lt, "suffix") : lore_sample(lt, "simple_suffix")
             when "Uncommon"
               rand < 0.3 ? lore_sample(lt, "simple_suffix") : nil
             else
               nil
             end

    parts = []
    parts << flavor if flavor && rand < 0.7
    parts << prefix
    parts << base
    parts << suffix if suffix

    parts.join(" ")
  end

  # ══════════════════════════════════════════════════════
  # DESCRIPTION GENERATION
  # ══════════════════════════════════════════════════════

  def self.generate_description(rarity_name, effects, category, weapon_name = nil, lore: "faerun")
    cat_singular = category.name.downcase.singularize
    item_word = weapon_name.present? ? weapon_name.downcase : cat_singular
    effect_types = effects.map(&:effect_type).uniq
    power = effects.sum(&:power_level)
    lt = lore.to_s

    case rarity_name
    when "Common"
      build_simple_description(lt, item_word, effect_types)
    when "Uncommon"
      build_uncommon_description(lt, rarity_name, item_word, effect_types)
    when "Rare"
      build_rare_description(lt, rarity_name, item_word, effect_types, power)
    when "Very Rare"
      build_elaborate_description(lt, rarity_name, item_word, effect_types, power)
    when "Legendary", "Ancestral"
      build_epic_description(lt, rarity_name, item_word, effect_types, power)
    else
      "A mysterious #{item_word} of unknown origin."
    end
  end

  private

  # ── Fill template placeholders with random lore from DB ──
  def self.fill_placeholders(text, lt)
    text.gsub("%{smith}",        lore_sample(lt, "smith") || "an unknown smith")
        .gsub("%{wielder}",      lore_sample(lt, "wielder") || "a forgotten hero")
        .gsub("%{event}",        lore_sample(lt, "event") || "a great battle")
        .gsub("%{place}",        lore_sample(lt, "place") || "a forgotten forge")
        .gsub("%{material}",     lore_sample(lt, "material") || "a rare metal")
        .gsub("%{organization}", lore_sample(lt, "organization") || "an ancient order")
        .gsub("%{deity}",        lore_sample(lt, "deity") || "a forgotten god")
        .gsub("%{era}",          lore_sample(lt, "age") || "an ancient era")
  end

  # ── Get an effect description, filling placeholders ──
  def self.effect_desc_for(lt, effect_type)
    desc = lore_sample(lt, "effect_description", effect_type)
    desc ? fill_placeholders(desc, lt) : nil
  end

  # ── Common: 1-2 sentences ──
  def self.build_simple_description(lt, item_word, effect_types)
    origin = fill_placeholders(lore_sample(lt, "origin", "Common") || "", lt)
    desc = "A reliable #{item_word} of honest craftsmanship. #{origin}"
    if effect_types.any?
      effect_desc = effect_desc_for(lt, effect_types.first)
      desc += " It #{effect_desc}." if effect_desc
    end
    desc
  end

  # ── Uncommon: 2-3 sentences ──
  def self.build_uncommon_description(lt, rarity_name, item_word, effect_types)
    origin = fill_placeholders(lore_sample(lt, "origin", rarity_name) || "", lt)
    desc = "An unusual #{item_word} that stands apart from ordinary craftsmanship. #{origin}"
    if effect_types.any?
      transition = lore_sample(lt, "effect_transition")
      effect_desc = effect_desc_for(lt, effect_types.first)
      desc += " #{transition} #{effect_desc}." if effect_desc && transition
    end
    desc += " #{lore_sample(lt, 'personality_trait')}" if rand < 0.5
    desc
  end

  # ── Rare: 3-5 sentences ──
  def self.build_rare_description(lt, rarity_name, item_word, effect_types, power)
    origin = fill_placeholders(lore_sample(lt, "origin", rarity_name) || "", lt)
    desc = "A remarkable #{item_word} that radiates quiet power. #{origin}"

    transitions = lore(lt, "effect_transition").shuffle
    effect_types.first(2).each_with_index do |et, i|
      effect_desc = effect_desc_for(lt, et)
      desc += " #{transitions[i] || lore_sample(lt, 'effect_transition')} #{effect_desc}." if effect_desc
    end

    if rand < 0.6
      anecdote = lore_sample(lt, "historical_anecdote")
      desc += " #{fill_placeholders(anecdote, lt)}" if anecdote
    end

    trait = lore_sample(lt, "personality_trait")
    desc += " #{trait}" if trait
    if rand < 0.3
      curse = lore_sample(lt, "curse")
      desc += " #{fill_placeholders(curse, lt)}" if curse
    end
    desc
  end

  # ── Very Rare: 4-6 sentences ──
  def self.build_elaborate_description(lt, rarity_name, item_word, effect_types, power)
    origin = fill_placeholders(lore_sample(lt, "origin", rarity_name) || "", lt)
    desc = origin.dup

    transitions = lore(lt, "effect_transition").shuffle
    effect_types.first(3).each_with_index do |et, i|
      effect_desc = effect_desc_for(lt, et)
      if effect_desc
        transition = transitions[i] || lore_sample(lt, "effect_transition")
        desc += " #{transition} #{effect_desc}."
      end
    end

    anecdote = lore_sample(lt, "historical_anecdote")
    desc += " #{fill_placeholders(anecdote, lt)}" if anecdote

    traits = LoreEntry.sample_many(lt, "personality_trait", count: rand(1..2))
    traits.each { |t| desc += " #{t}" }

    if rand < 0.5
      curse = lore_sample(lt, "curse")
      desc += " #{fill_placeholders(curse, lt)}" if curse
    end
    if rand < 0.3
      prophecy = lore_sample(lt, "prophecy")
      desc += " #{fill_placeholders(prophecy, lt)}" if prophecy
    end
    desc
  end

  # ── Legendary & Ancestral: 6+ sentences ──
  def self.build_epic_description(lt, rarity_name, item_word, effect_types, power)
    origin = fill_placeholders(lore_sample(lt, "origin", rarity_name) || "", lt)
    desc = origin.dup

    transitions = lore(lt, "effect_transition").shuffle
    effect_types.each_with_index do |et, i|
      effect_desc = effect_desc_for(lt, et)
      if effect_desc
        transition = transitions[i] || lore_sample(lt, "effect_transition")
        desc += " #{transition} #{effect_desc}."
      end
    end

    anecdotes = LoreEntry.sample_many(lt, "historical_anecdote", count: 2)
    anecdotes.each { |a| desc += " #{fill_placeholders(a, lt)}" }

    traits = LoreEntry.sample_many(lt, "personality_trait", count: rand(2..3))
    traits.each { |t| desc += " #{t}" }

    curse = lore_sample(lt, "curse")
    desc += " Furthermore, #{fill_placeholders(curse, lt)}." if curse
    if rand < 0.6
      prophecy = lore_sample(lt, "prophecy")
      desc += " #{fill_placeholders(prophecy, lt)}" if prophecy
    end

    closing = lore_sample(lt, "dramatic_closing")
    desc += " #{closing}" if closing
    desc
  end

  public

  # ══════════════════════════════════════════════════════
  # RECOMMENDATIONS
  # ══════════════════════════════════════════════════════

  def self.recommend_effects(category, selected_effect_types, available_power)
    available = Effect.joins(:categories)
                      .where(categories: { id: category.id })
                      .where.not(effect_type: selected_effect_types)
                      .where("power_level <= ?", available_power)

    conflicting_types = selected_effect_types.flat_map { |t| CONFLICTS[t] || [] }.uniq
    available = available.where.not(effect_type: conflicting_types) if conflicting_types.any?

    synergy_types = selected_effect_types.flat_map { |t| SYNERGIES[t] || [] }.uniq
    scored = available.map do |effect|
      score = synergy_types.include?(effect.effect_type) ? 10 : 0
      score += 5 if effect.power_level <= available_power
      score += 3 if effect.power_level == available_power
      { effect: effect, score: score, synergy: synergy_types.include?(effect.effect_type) }
    end

    scored.sort_by { |s| -s[:score] }
  end

  def self.conflicts?(effect_type, selected_types)
    selected_types.any? { |t| (CONFLICTS[t] || []).include?(effect_type) }
  end

  def self.synergies_for(selected_types)
    selected_types.flat_map { |t| SYNERGIES[t] || [] }.uniq - selected_types
  end
end
