class SeedLoreEntries < ActiveRecord::Migration[7.2]
  def up
    seed_faerun_lore
    seed_middle_earth_lore
  end

  def down
    execute "DELETE FROM lore_entries"
  end

  private

  def bulk_insert(lore_type, category, values, key: nil)
    now = Time.current
    records = values.map do |v|
      { lore_type: lore_type, category: category, key: key, value: v, created_at: now, updated_at: now }
    end
    LoreEntry.insert_all(records) if records.any?
  end

  def bulk_insert_hash(lore_type, category, hash)
    now = Time.current
    records = hash.flat_map do |k, values|
      values.map { |v| { lore_type: lore_type, category: category, key: k.to_s, value: v, created_at: now, updated_at: now } }
    end
    LoreEntry.insert_all(records) if records.any?
  end

  # ═══════════════════════════════════════════════
  # FAERÛN LORE
  # ═══════════════════════════════════════════════
  def seed_faerun_lore
    lt = "faerun"

    # Prefixes (keyed by rarity)
    bulk_insert_hash(lt, "prefix", {
      "Common"    => %w[Worn Sturdy Rustic Humble Steady Simple Honest Faithful Trusted Tempered Battered Reliable Solid Modest Seasoned],
      "Uncommon"  => %w[Keen Glinting Blessed Warden's Vigilant Stalwart Noble Radiant Swift Valiant Gleaming Embered Sigiled Ironsworn Resolute],
      "Rare"      => %w[Arcane Runed Enchanted Mystic Phantom Spectral Hallowed Infernal Crimson Emerald Silvered Moonforged Starlit Wyrmtouched Spellwoven],
      "Very Rare" => %w[Astral Void-touched Planar Eldritch Ethereal Abyssal Celestial Draconic Shadow-forged Soul-bound Mythal-woven Netherese Weave-spun Primeval Fey-wrought],
      "Legendary" => %w[Godslayer World-ender Titan's Doom-forged Immortal Sovereign Apocalyptic Eternal Mythic Exalted Epoch-defining Cataclysmic Divine Transcendent Fate-sealed],
      "Ancestral" => %w[Primordial Cosmic Genesis Origin World-seed First-forged Timeless Infinite Ur-ancient Boundless Reality-born Void-wrought Aeon-touched Creation's Omniscient],
    })

    # Category titles (keyed by category name)
    bulk_insert_hash(lt, "category_title", {
      "Weapons"    => %w[Blade Edge Fang Wrath Fury Vengeance Reckoning Judgment Bane Reaver Talon Sting Cleaver Ruin],
      "Armor"      => %w[Bulwark Bastion Aegis Ward Rampart Fortress Sentinel Shell Carapace Plate Mantle Harness Panoply],
      "Shields"    => %w[Wall Guardian Barrier Ward Buckler Defender Protector Vigil Aegis Bulwark Phalanx Redoubt Rampart],
      "Potions"    => %w[Elixir Brew Draught Tincture Philter Essence Vial Ichor Distillation Concoction Infusion Flask Cordial],
      "Scrolls"    => %w[Codex Tome Script Decree Sigil Glyph Mandate Writ Proclamation Litany Grimoire Folio Testament],
      "Rings"      => %w[Band Circle Loop Signet Circlet Seal Coil Ring Orbit Whorl Crown Annulus Cipher],
      "Amulets"    => %w[Talisman Pendant Charm Locket Medallion Token Emblem Jewel Phylactery Reliquary Wardstone Focus],
      "Wands"      => %w[Rod Scepter Baton Focus Wand Conduit Channeler Beacon Implement Stylus Catalyst Spark],
      "Staffs"     => %w[Pillar Spire Rod Crook Staff Scepter Mace Stave Crozier Column Obelisk Monolith],
      "Boots"      => %w[Treads Striders Walkers Greaves Steps Runners Kicks Sabatons Trackers Pathfinders Wanderers Sojourners],
      "Gloves"     => %w[Grasp Clutch Grip Gauntlets Mitts Hands Fists Touch Fingers Vambraces Bracers Talons],
      "Helms"      => %w[Crown Visor Casque Crest Diadem Helm Mantle Pinnacle Coronet Circlet Tiara Sallet],
      "Cloaks"     => %w[Shroud Mantle Veil Cape Drape Cloak Shadow Wrap Pall Vestment Cowl Raiment],
      "Books"      => %w[Grimoire Lexicon Codex Compendium Chronicle Almanac Opus Volume Libram Enchiridion Palimpsest Folio],
      "Gems"       => %w[Prism Shard Crystal Jewel Stone Heart Eye Tear Facet Geode Orb Mote],
      "Ammunition" => %w[Bolt Arrow Dart Quarrel Shot Missile Round Slug Shaft Spike Needle],
      "Bracelet"   => %w[Bangle Cuff Chain Torc Armlet Circlet Shackle Link Fetter Coil Band],
      "Trinkets"   => %w[Curio Bauble Keepsake Relic Token Oddity Fetish Memento Charm Knickknack Icon],
    })

    # Suffixes (flat list)
    bulk_insert(lt, "suffix", FaerunLore::SUFFIXES)
    bulk_insert(lt, "simple_suffix", FaerunLore::SIMPLE_SUFFIXES)

    # Lore constants (flat lists)
    bulk_insert(lt, "smith", FaerunLore::LEGENDARY_SMITHS)
    bulk_insert(lt, "wielder", FaerunLore::LEGENDARY_WIELDERS)
    bulk_insert(lt, "place", FaerunLore::LEGENDARY_PLACES)
    bulk_insert(lt, "event", FaerunLore::LEGENDARY_EVENTS)
    bulk_insert(lt, "deity", FaerunLore::DEITIES)
    bulk_insert(lt, "organization", FaerunLore::ORGANIZATIONS)
    bulk_insert(lt, "material", FaerunLore::EXOTIC_MATERIALS)
    bulk_insert(lt, "age", FaerunLore::AGES_AND_ERAS)
    bulk_insert(lt, "curse", FaerunLore::CURSES_AND_QUIRKS)
    bulk_insert(lt, "prophecy", FaerunLore::PROPHECIES)
    bulk_insert(lt, "personality_trait", FaerunLore::PERSONALITY_TRAITS)
    bulk_insert(lt, "dramatic_closing", FaerunLore::DRAMATIC_CLOSINGS)
    bulk_insert(lt, "effect_transition", FaerunLore::EFFECT_TRANSITIONS)
    bulk_insert(lt, "historical_anecdote", FaerunLore::HISTORICAL_ANECDOTES)

    # Origins (keyed by rarity)
    bulk_insert_hash(lt, "origin", FaerunLore::ORIGINS)

    # Effect descriptions (keyed by effect_type)
    bulk_insert_hash(lt, "effect_description", FaerunLore::EFFECT_DESCRIPTIONS)

    # Effect flavor (keyed by effect_type)
    bulk_insert_hash(lt, "effect_flavor", FaerunLore::EFFECT_FLAVOR)
  end

  # ═══════════════════════════════════════════════
  # MIDDLE-EARTH LORE
  # ═══════════════════════════════════════════════
  def seed_middle_earth_lore
    lt = "middle_earth"

    bulk_insert_hash(lt, "prefix", MiddleEarthLore::PREFIXES)
    bulk_insert_hash(lt, "category_title", MiddleEarthLore::CATEGORY_TITLES)
    bulk_insert(lt, "suffix", MiddleEarthLore::SUFFIXES)
    bulk_insert(lt, "simple_suffix", MiddleEarthLore::SIMPLE_SUFFIXES)
    bulk_insert(lt, "smith", MiddleEarthLore::LEGENDARY_SMITHS)
    bulk_insert(lt, "wielder", MiddleEarthLore::LEGENDARY_WIELDERS)
    bulk_insert(lt, "place", MiddleEarthLore::LEGENDARY_PLACES)
    bulk_insert(lt, "event", MiddleEarthLore::LEGENDARY_EVENTS)
    bulk_insert(lt, "deity", MiddleEarthLore::DEITIES)
    bulk_insert(lt, "organization", MiddleEarthLore::ORGANIZATIONS)
    bulk_insert(lt, "material", MiddleEarthLore::EXOTIC_MATERIALS)
    bulk_insert(lt, "age", MiddleEarthLore::AGES_AND_ERAS)
    bulk_insert(lt, "curse", MiddleEarthLore::CURSES_AND_QUIRKS)
    bulk_insert(lt, "prophecy", MiddleEarthLore::PROPHECIES)
    bulk_insert(lt, "personality_trait", MiddleEarthLore::PERSONALITY_TRAITS)
    bulk_insert(lt, "dramatic_closing", MiddleEarthLore::DRAMATIC_CLOSINGS)
    bulk_insert(lt, "effect_transition", MiddleEarthLore::EFFECT_TRANSITIONS)
    bulk_insert(lt, "historical_anecdote", MiddleEarthLore::HISTORICAL_ANECDOTES)
    bulk_insert_hash(lt, "origin", MiddleEarthLore::ORIGINS)
    bulk_insert_hash(lt, "effect_description", MiddleEarthLore::EFFECT_DESCRIPTIONS)

    # Effect flavor is shared — use Faerun's (already in DB), but ME needs its own copy
    # For now, ME shares the same effect_flavor as Faerun
    bulk_insert_hash(lt, "effect_flavor", FaerunLore::EFFECT_FLAVOR)
  end
end
