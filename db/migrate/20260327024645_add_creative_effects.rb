class AddCreativeEffects < ActiveRecord::Migration[7.2]
  def up
    # Fetch categories for associations
    cats = {}
    %w[Weapons Armor Shields Amulets Rings Gems Boots Cloak Wands Trinkets
       Gloves Potions Helms Staffs Bracelet Ammunition Scrolls Books
       Candle Elixirs Food Horns Miscellaneous Tools Artifacts].each do |name|
      cats[name] = Category.find_by(name: name)
    end

    # Helper to compact category arrays
    c = ->(names) { names.filter_map { |n| cats[n] } }

    effects_data = [
      # ═══════════════════════════════════════════
      # LUCK — quirky fortune effects
      # ═══════════════════════════════════════════
      { name: "Gambler's Grace", effect_type: "Luck", power_level: 1,
        description: "Once per day, you may reroll any d20 and keep the second result. The item whispers 'double or nothing' each time.",
        categories: c.(%w[Rings Amulets Trinkets Gems]) },

      { name: "Fool's Fortune", effect_type: "Luck", power_level: 2,
        description: "When you roll a natural 1, you may treat it as a natural 20 once per long rest. The item giggles maniacally when triggered.",
        categories: c.(%w[Rings Amulets Trinkets]) },

      { name: "Lucky Coin Flip", effect_type: "Luck", power_level: 1,
        description: "Summon a spectral coin. Heads grants advantage on your next roll; tails gives disadvantage. Fate loves a gambler.",
        categories: c.(%w[Trinkets Rings Gems]) },

      { name: "Jinxbreaker", effect_type: "Luck", power_level: 3,
        description: "Negate one critical hit against you per day. The attack still hits but deals normal damage instead.",
        categories: c.(%w[Amulets Rings Shields Armor]) },

      # ═══════════════════════════════════════════
      # SUMMONING — conjure allies and creatures
      # ═══════════════════════════════════════════
      { name: "Pocket Familiar", effect_type: "Summoning", power_level: 1,
        description: "Summon a tiny spectral animal companion (cat, owl, or toad). It can scout 60 ft and relay what it sees telepathically.",
        categories: c.(%w[Rings Amulets Trinkets Wands]) },

      { name: "Swarm Caller", effect_type: "Summoning", power_level: 3,
        description: "Once per day, summon a swarm of spectral insects that harass enemies in a 15-ft area, imposing disadvantage on concentration checks.",
        categories: c.(%w[Staffs Wands Rings]) },

      { name: "Shadow Servant", effect_type: "Summoning", power_level: 2,
        description: "Summon an obedient shadow that can carry up to 30 lbs, open doors, and perform simple tasks. Lasts 1 hour.",
        categories: c.(%w[Rings Amulets Cloak]) },

      { name: "Phantasmal Steed", effect_type: "Summoning", power_level: 3,
        description: "Summon a ghostly horse with 60 ft speed and the ability to gallop across water. Lasts 1 hour, once per long rest.",
        categories: c.(%w[Boots Rings Amulets]) },

      # ═══════════════════════════════════════════
      # CONTROL — battlefield manipulation
      # ═══════════════════════════════════════════
      { name: "Gravity Well", effect_type: "Control", power_level: 3,
        description: "Once per day, create a 20-ft zone of intense gravity. Creatures entering must succeed on a STR save or be restrained for 1 round.",
        categories: c.(%w[Staffs Wands Rings Gems]) },

      { name: "Puppet Strings", effect_type: "Control", power_level: 4,
        description: "As an action, force one humanoid within 30 ft to make a WIS save or be compelled to move 15 ft in a direction you choose.",
        categories: c.(%w[Gloves Rings Wands]) },

      { name: "Terrain Sculptor", effect_type: "Control", power_level: 2,
        description: "Shape a 10-ft square of earth, stone, or ice into difficult terrain or smooth ground. The reshaping lasts 10 minutes.",
        categories: c.(%w[Staffs Wands Gloves]) },

      # ═══════════════════════════════════════════
      # MINDING — psychic and mental effects
      # ═══════════════════════════════════════════
      { name: "Thought Echo", effect_type: "Minding", power_level: 2,
        description: "Read the surface thoughts of one creature within 30 ft for 1 minute, once per day. They feel a faint tickle but don't know the source.",
        categories: c.(%w[Helms Amulets Rings]) },

      { name: "Dream Weaver", effect_type: "Minding", power_level: 3,
        description: "Send a message to a sleeping creature you know by name, anywhere on the same plane. They experience it as a vivid dream.",
        categories: c.(%w[Amulets Rings Gems Trinkets]) },

      { name: "Psychic Scream", effect_type: "Minding", power_level: 4,
        description: "Release a mental blast in a 15-ft cone. Each creature must succeed on an INT save or take 3d6 psychic damage and be stunned until end of their next turn. Once per long rest.",
        categories: c.(%w[Helms Staffs Wands]) },

      # ═══════════════════════════════════════════
      # VISION — sight and perception
      # ═══════════════════════════════════════════
      { name: "Eagle Eye", effect_type: "Vision", power_level: 1,
        description: "You can see clearly up to 1 mile as if it were only 30 feet away. Works like a built-in spyglass.",
        categories: c.(%w[Helms Rings Amulets Trinkets]) },

      { name: "Spectral Sight", effect_type: "Vision", power_level: 3,
        description: "See into the Ethereal Plane within 60 ft. Invisible creatures and objects appear as faint translucent silhouettes.",
        categories: c.(%w[Helms Rings Gems]) },

      { name: "Memory Lens", effect_type: "Vision", power_level: 2,
        description: "Touch an object to see a 30-second vision of the last significant event that occurred near it. Once per short rest.",
        categories: c.(%w[Rings Gems Trinkets]) },

      # ═══════════════════════════════════════════
      # FLIGHT — airborne effects
      # ═══════════════════════════════════════════
      { name: "Windrunner", effect_type: "Flight", power_level: 2,
        description: "Gain a flying speed of 30 ft for 1 minute, once per day. A trail of glowing feathers marks your path.",
        categories: c.(%w[Boots Cloak Rings]) },

      { name: "Levitation Field", effect_type: "Flight", power_level: 1,
        description: "Hover up to 5 ft above the ground at will. You ignore ground-based traps and difficult terrain but can't ascend higher.",
        categories: c.(%w[Boots Rings Amulets]) },

      { name: "Storm Rider", effect_type: "Flight", power_level: 4,
        description: "Gain a flying speed of 60 ft for 10 minutes, once per long rest. Lightning crackles around you, dealing 1d4 to creatures you fly past.",
        categories: c.(%w[Cloak Boots Staffs]) },

      # ═══════════════════════════════════════════
      # SPEED — movement and agility
      # ═══════════════════════════════════════════
      { name: "Blink Step", effect_type: "Speed", power_level: 2,
        description: "As a bonus action, teleport up to 15 ft to an unoccupied space you can see. You leave a puff of smoke behind. 3 uses per long rest.",
        categories: c.(%w[Boots Rings Amulets]) },

      { name: "Afterimage", effect_type: "Speed", power_level: 3,
        description: "When you take the Dash action, leave a translucent copy of yourself behind. The copy lasts 1 round and enemies have disadvantage on attacks against you while it exists.",
        categories: c.(%w[Boots Cloak Rings]) },

      { name: "Quicksilver Reflexes", effect_type: "Speed", power_level: 2,
        description: "You can take reactions twice per round instead of once. Your movements shimmer with a mercurial glow.",
        categories: c.(%w[Gloves Boots Bracelet]) },

      # ═══════════════════════════════════════════
      # HEALING — restoration and vitality
      # ═══════════════════════════════════════════
      { name: "Life Leech", effect_type: "Healing", power_level: 2,
        description: "On a successful melee hit, regain HP equal to half the damage dealt. Works once per short rest. The weapon pulses with a crimson glow.",
        categories: c.(%w[Weapons Gloves]) },

      { name: "Phoenix Tear", effect_type: "Healing", power_level: 4,
        description: "When you drop to 0 HP, immediately regain 3d8+5 HP and stand up. This destroys the tear. A burst of golden fire erupts around you.",
        categories: c.(%w[Amulets Gems Rings]) },

      { name: "Sanguine Bond", effect_type: "Healing", power_level: 3,
        description: "As an action, sacrifice up to 20 of your HP to heal an ally within touch range for the same amount plus 1d8. Once per long rest.",
        categories: c.(%w[Rings Amulets Gloves]) },

      # ═══════════════════════════════════════════
      # PROTECTION — defensive magic
      # ═══════════════════════════════════════════
      { name: "Mirror Ward", effect_type: "Protection", power_level: 3,
        description: "Once per day, reflect the next spell of 3rd level or lower cast at you back at the caster, using their own spell attack or save DC.",
        categories: c.(%w[Shields Armor Amulets]) },

      { name: "Death's Denial", effect_type: "Protection", power_level: 5,
        description: "Once per week, when you would be killed, time freezes for 6 seconds. You are stabilized at 1 HP and teleported 30 ft in a random direction.",
        categories: c.(%w[Amulets Rings Armor]) },

      { name: "Absorb Elements", effect_type: "Protection", power_level: 2,
        description: "As a reaction when hit by elemental damage, gain resistance to that damage type until start of your next turn. 3 uses per long rest.",
        categories: c.(%w[Shields Armor Rings Bracelet]) },

      # ═══════════════════════════════════════════
      # FROSTING — ice and cold effects
      # ═══════════════════════════════════════════
      { name: "Glacial Prison", effect_type: "Frosting", power_level: 3,
        description: "On a critical hit, the target is encased in ice and restrained until they succeed on a STR save at the start of their turn.",
        categories: c.(%w[Weapons Ammunition Staffs]) },

      { name: "Winter's Breath", effect_type: "Frosting", power_level: 2,
        description: "As an action, exhale a 15-ft cone of frost. Creatures in the area take 2d6 cold damage and their speed is halved for 1 round. 2 uses per day.",
        categories: c.(%w[Helms Amulets Rings]) },

      # ═══════════════════════════════════════════
      # LIGHTNING — electric and thunder effects
      # ═══════════════════════════════════════════
      { name: "Chain Lightning Strike", effect_type: "Lightning", power_level: 3,
        description: "On a hit, lightning arcs to up to 2 additional creatures within 15 ft, dealing 1d6 lightning damage to each. Once per short rest.",
        categories: c.(%w[Weapons Staffs Wands]) },

      { name: "Thunderclap", effect_type: "Lightning", power_level: 2,
        description: "As an action, slam the item to create a thunderclap in a 10-ft radius. Creatures must make a CON save or be deafened and pushed 5 ft. 3 uses per day.",
        categories: c.(%w[Weapons Shields Staffs]) },

      # ═══════════════════════════════════════════
      # UTILITY — fun and quirky effects
      # ═══════════════════════════════════════════
      { name: "Mood Ring", effect_type: "Utility", power_level: 1,
        description: "Changes color based on the emotional state of the nearest creature. Red = angry, blue = sad, green = calm, gold = happy.",
        categories: c.(%w[Rings Trinkets]) },

      { name: "Portable Campfire", effect_type: "Utility", power_level: 1,
        description: "Summon a small magical campfire that provides warmth, light (20 ft), and cooks food without fuel. Lasts 8 hours.",
        categories: c.(%w[Trinkets Gems Tools]) },

      { name: "Bag of Holding (Mini)", effect_type: "Utility", power_level: 2,
        description: "This tiny pouch can hold up to 50 lbs of items in an extradimensional space no larger than 2 cubic feet.",
        categories: c.(%w[Trinkets Miscellaneous]) },

      { name: "Bardic Echo", effect_type: "Utility", power_level: 1,
        description: "This item can record up to 1 minute of sound and play it back at will. Perfect for dramatic entrances or repeating crucial conversations.",
        categories: c.(%w[Trinkets Gems Horns]) },

      { name: "Unseen Butler", effect_type: "Utility", power_level: 2,
        description: "Summon an invisible servant that sets up camp, cleans equipment, and serves meals. It cannot fight or carry more than 10 lbs.",
        categories: c.(%w[Rings Trinkets Miscellaneous]) },

      { name: "Translator's Tongue", effect_type: "Understanding", power_level: 2,
        description: "Understand and speak any language for 10 minutes, 3 times per day. Your words have a faint magical echo.",
        categories: c.(%w[Amulets Rings Helms]) },

      { name: "Diplomat's Charm", effect_type: "Utility", power_level: 2,
        description: "Gain advantage on Persuasion checks for 10 minutes, once per day. A faint golden aura surrounds you when active.",
        categories: c.(%w[Amulets Rings Gems Bracelet]) },

      { name: "Chrono Pocket Watch", effect_type: "Utility", power_level: 3,
        description: "Once per day, rewind time by 6 seconds. You return to where you were and can take your last turn differently. Others don't notice the shift.",
        categories: c.(%w[Trinkets Rings Gems]) },

      # ═══════════════════════════════════════════
      # STEALTH — shadow and concealment
      # ═══════════════════════════════════════════
      { name: "Smoke Bomb", effect_type: "Stealth", power_level: 1,
        description: "As a bonus action, throw a smoke bomb creating a 10-ft radius of heavy obscurement that lasts 1 round. 3 uses per day.",
        categories: c.(%w[Trinkets Gloves Cloak]) },

      { name: "Chameleon Skin", effect_type: "Stealth", power_level: 2,
        description: "While motionless, you become nearly invisible, gaining advantage on Stealth checks and +5 to your passive Stealth.",
        categories: c.(%w[Cloak Armor Rings]) },

      { name: "Silence Aura", effect_type: "Stealth", power_level: 2,
        description: "Create a 5-ft sphere of silence around you for 1 minute, 2 times per day. No sound enters or leaves the sphere.",
        categories: c.(%w[Boots Cloak Amulets]) },

      # ═══════════════════════════════════════════
      # ELIXIRS & SCROLLS — consumable-style effects
      # ═══════════════════════════════════════════
      { name: "Scroll of Doppelganger", effect_type: "Control", power_level: 3,
        description: "Create an illusory double of yourself that mimics your actions 30 ft away. Lasts 1 minute. Enemies must guess which is real.",
        categories: c.(%w[Scrolls Wands]) },

      { name: "Elixir of Iron Will", effect_type: "Resistance", power_level: 2,
        description: "Gain advantage on all Wisdom saving throws for 1 hour. Your eyes glow with a faint silver light.",
        categories: c.(%w[Elixirs Potions]) },

      { name: "Elixir of Giant's Grasp", effect_type: "Enhance", power_level: 2,
        description: "Your hands grow to twice their size for 10 minutes. Grapple checks gain advantage and your unarmed strikes deal 1d8 damage.",
        categories: c.(%w[Elixirs Potions]) },

      { name: "Scroll of Gravity Inversion", effect_type: "Control", power_level: 2,
        description: "Reverse gravity in a 20-ft area for 1 round. Creatures must succeed on a DEX save or fall upward 20 ft, then crash back down.",
        categories: c.(%w[Scrolls Wands Staffs]) },

      # ═══════════════════════════════════════════
      # FOOD & CANDLE — fun consumables
      # ═══════════════════════════════════════════
      { name: "Bottomless Ration", effect_type: "Utility", power_level: 1,
        description: "This piece of bread regenerates overnight. It always tastes fresh and provides a full day's nourishment.",
        categories: c.(%w[Food Trinkets]) },

      { name: "Morale Feast", effect_type: "Healing", power_level: 1,
        description: "When shared among up to 6 creatures, this food grants 1d6 temporary HP and removes the frightened condition.",
        categories: c.(%w[Food]) },

      { name: "Candle of Truth", effect_type: "Control", power_level: 2,
        description: "While this candle burns (1 hour), creatures within 10 ft must succeed on a CHA save to deliberately speak a lie.",
        categories: c.(%w[Candle Trinkets]) },

      { name: "Candle of Restful Sleep", effect_type: "Healing", power_level: 1,
        description: "Creatures who complete a long rest within 30 ft of this burning candle regain an additional Hit Die.",
        categories: c.(%w[Candle Trinkets]) },

      # ═══════════════════════════════════════════
      # BOOKS & ARTIFACTS — knowledge effects
      # ═══════════════════════════════════════════
      { name: "Tome of Forgotten Lore", effect_type: "Enhance", power_level: 3,
        description: "Once per day, ask the book one question about history, arcana, or religion and receive a truthful (but cryptic) answer.",
        categories: c.(%w[Books Artifacts Scrolls]) },

      { name: "Grimoire of Spell Theft", effect_type: "Absortion", power_level: 4,
        description: "When you succeed on a saving throw against a spell, you can capture it in this book. Cast it once within 24 hours using the original caster's save DC.",
        categories: c.(%w[Books Artifacts]) },

      { name: "Atlas of Hidden Paths", effect_type: "Detection", power_level: 2,
        description: "This map reveals secret doors, hidden passages, and traps within 100 ft. Updates in real-time as you explore.",
        categories: c.(%w[Books Scrolls Trinkets]) },

      # ═══════════════════════════════════════════
      # GEMS & ARTIFACTS — powerful rare effects
      # ═══════════════════════════════════════════
      { name: "Soul Anchor", effect_type: "Protection", power_level: 4,
        description: "You cannot be banished, teleported against your will, or sent to another plane. The gem glows with a deep violet light.",
        categories: c.(%w[Gems Artifacts Amulets]) },

      { name: "Chaos Shard", effect_type: "Luck", power_level: 3,
        description: "On each attack, roll 1d6: 1-2 = extra 2d6 damage, 3-4 = normal, 5 = attack misses, 6 = target and attacker both take 1d6 force damage. Chaos reigns.",
        categories: c.(%w[Gems Weapons Rings]) },

      { name: "Time Crystal", effect_type: "Speed", power_level: 4,
        description: "Once per long rest, take an additional full turn immediately after your current turn. The crystal cracks slightly each time.",
        categories: c.(%w[Gems Artifacts Rings]) },

      { name: "Dimensional Pocket", effect_type: "Utility", power_level: 3,
        description: "Open a 5-ft portal to a personal pocket dimension (10x10x10 ft). Items stored inside persist indefinitely. 2 uses per day.",
        categories: c.(%w[Gems Artifacts Rings]) },
    ]

    effects_data.each do |data|
      categories = data.delete(:categories)
      effect = Effect.create!(data)
      effect.categories = categories if categories.present?
    end

    puts "Created #{effects_data.size} creative effects!"
  end

  def down
    creative_names = [
      "Gambler's Grace", "Fool's Fortune", "Lucky Coin Flip", "Jinxbreaker",
      "Pocket Familiar", "Swarm Caller", "Shadow Servant", "Phantasmal Steed",
      "Gravity Well", "Puppet Strings", "Terrain Sculptor",
      "Thought Echo", "Dream Weaver", "Psychic Scream",
      "Eagle Eye", "Spectral Sight", "Memory Lens",
      "Windrunner", "Levitation Field", "Storm Rider",
      "Blink Step", "Afterimage", "Quicksilver Reflexes",
      "Life Leech", "Phoenix Tear", "Sanguine Bond",
      "Mirror Ward", "Death's Denial", "Absorb Elements",
      "Glacial Prison", "Winter's Breath",
      "Chain Lightning Strike", "Thunderclap",
      "Mood Ring", "Portable Campfire", "Bag of Holding (Mini)", "Bardic Echo",
      "Unseen Butler", "Translator's Tongue", "Diplomat's Charm", "Chrono Pocket Watch",
      "Smoke Bomb", "Chameleon Skin", "Silence Aura",
      "Scroll of Doppelganger", "Elixir of Iron Will", "Elixir of Giant's Grasp",
      "Scroll of Gravity Inversion",
      "Bottomless Ration", "Morale Feast", "Candle of Truth", "Candle of Restful Sleep",
      "Tome of Forgotten Lore", "Grimoire of Spell Theft", "Atlas of Hidden Paths",
      "Soul Anchor", "Chaos Shard", "Time Crystal", "Dimensional Pocket",
    ]
    Effect.where(name: creative_names).destroy_all
  end
end
