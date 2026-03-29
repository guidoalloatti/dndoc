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
  # NAME GENERATION — epic, unique item names
  # ══════════════════════════════════════════════════════

  PREFIXES = {
    "Common"    => %w[Worn Sturdy Rustic Humble Steady Simple Honest Faithful Trusted Tempered Battered Reliable Solid Modest Seasoned],
    "Uncommon"  => %w[Keen Glinting Blessed Warden's Vigilant Stalwart Noble Radiant Swift Valiant Gleaming Embered Sigiled Ironsworn Resolute],
    "Rare"      => %w[Arcane Runed Enchanted Mystic Phantom Spectral Hallowed Infernal Crimson Emerald Silvered Moonforged Starlit Wyrmtouched Spellwoven],
    "Very Rare" => %w[Astral Void-touched Planar Eldritch Ethereal Abyssal Celestial Draconic Shadow-forged Soul-bound Mythal-woven Netherese Weave-spun Primeval Fey-wrought],
    "Legendary" => %w[Godslayer World-ender Titan's Doom-forged Immortal Sovereign Apocalyptic Eternal Mythic Exalted Epoch-defining Cataclysmic Divine Transcendent Fate-sealed],
    "Ancestral" => %w[Primordial Cosmic Genesis Origin World-seed First-forged Timeless Infinite Ur-ancient Boundless Reality-born Void-wrought Aeon-touched Creation's Omniscient],
  }.freeze

  CATEGORY_TITLES = {
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
  }.freeze

  EFFECT_FLAVOR = {
    "Attack Bonus"   => %w[Striking Cleaving Smiting Piercing Slashing Rending Sundering Reaping Keen-edged Vorpal],
    "Attack Damage"  => %w[Blazing Frozen Thundering Withering Searing Devastating Cataclysmic Ruinous Scorching Annihilating],
    "Defense"        => %w[Warding Shielding Fortifying Guarding Bolstering Unbreakable Stalwart Impregnable Bulwarking Ironclad],
    "Healing"        => %w[Mending Restoring Renewing Reviving Soothing Rejuvenating Life-giving Verdant Nurturing Sanctified],
    "Material"       => %w[Adamantine Mithral Orichalcum Starmetal Moonsilver Darksteel Glassteel Byeshk Hizagkuur Baatorian],
    "Stealth"        => %w[Shadowed Silent Unseen Phantom Veiled Ghostly Wraithlike Obscured Eclipsed Invisible],
    "Speed"          => %w[Swift Hastened Quicksilver Windborne Blurring Fleet Zephyr Mercurial Darting Streaking],
    "Protection"     => %w[Blessed Hallowed Sanctified Consecrated Empowered Aegis-bound Charmed Warded Providence-kissed Sheltered],
    "Resistance"     => %w[Resilient Unyielding Impervious Unbreakable Enduring Indomitable Steadfast Unbowed Obdurate Immutable],
    "Conjuration"    => %w[Summoner's Invoker's Caller's Conjurer's Binder's Gate-opener's Planar Rift-born Dimensional Manifesting],
    "Flight"         => %w[Soaring Skybound Winged Ascending Levitating Cloud-walking Zephyrous Storm-riding Eagle's Raptor],
    "Frosting"       => %w[Glacial Frostbitten Frozen Winterborn Icebound Hoarfrost Rime-touched Permafrost Blizzard-forged Arctic],
    "Lightning"      => %w[Thunderstruck Stormborn Voltaic Tempest Crackling Arc-forged Galvanic Storm-herald Fulgurant Lightning-veined],
    "Vision"         => %w[All-seeing Eagle-eyed Truesight Perceptive Vigilant Oracle's Farsighted Prescient Clairvoyant Omniscient],
    "Luck"           => %w[Fortunate Fated Destined Charmed Blessed Serendipitous Auspicious Star-crossed Providence Fortune-favored],
    "Control"        => %w[Dominating Commanding Bending Ruling Binding Compelling Enthralling Subjugating Sovereign Imperious],
    "Minding"        => %w[Psionic Telepathic Thought-born Mind-forged Cerebral Cognizant Sentient Prescient Omniscient Noetic],
    "Summoning"      => %w[Caller's Invoker's Harbinger's Beckoning Spiritbound Covenant Herald's Pact-sworn Theurge's Conclave],
    "Enhance"        => %w[Empowered Augmented Ascendant Transcendent Fortified Exalted Apotheotic Sublime Perfected Magnified],
    "Utility"        => %w[Versatile Ingenious Resourceful Practical Clever Adaptive Multifaceted Protean Polymorphic Inventive],
    "Understanding"  => %w[Omnilingual Polyglot Worldly Learned Sage Scholarly Erudite Enlightened Sapient Illuminated],
    "Absortion"      => %w[Devouring Consuming Absorbing Nullifying Siphoning Leeching Draining Engulfing Ravenous Voracious],
    "Saving Throws"  => %w[Resolute Unwavering Indomitable Steadfast Unflinching Stalwart Unshakable Dauntless Tenacious Implacable],
    "Initiative"     => %w[Swift Prescient Alert Vigilant Ready Hair-trigger Lightning-fast Reactive Quickened Anticipating],
    "Ammunition Magic" => %w[Homing Seeking Piercing Unerring True-flying Relentless Returning Ricocheting Penetrating Guided],
    "Inmunity"       => %w[Impervious Invulnerable Untouchable Proof Immune Shielded Negating Absolute Inviolable Sacrosanct],
    "Knocking"       => %w[Crushing Battering Thunderous Staggering Concussive Hammering Impact Shattering Pummeling Quaking],
    "Flexibility"    => %w[Adaptive Fluid Versatile Shifting Morphic Responsive Reactive Malleable Dynamic Mutable],
    "Sentient"       => %w[Awakened Living Conscious Sentient Sapient Willful Autonomous Self-aware Cognizant Ensouled],
    "Traces"         => %w[Trackless Wandering Pathless Ghostwalking Untraceable Evasive Elusive Misleading Phantom Deceptive],
    "Restoration"    => %w[Rejuvenating Revitalizing Regenerating Invigorating Life-sustaining Renewing Restorative Vivifying Curative Mending],
    "Detection"      => %w[Revealing Uncovering Discerning Perceiving Detecting Unveiling Exposing Scanning Probing Divining],
    "Movement"       => %w[Striding Bounding Leaping Dashing Sprinting Gliding Traversing Vaulting Surging Racing],
  }.freeze

  # ── Suffixes: Faerûn-flavored, massive variety ──
  SUFFIXES = [
    # Classic Forgotten Realms locations
    "of the Sword Coast", "of Undermountain", "of the Spine of the World",
    "of the High Forest", "of the Anauroch", "of the Moonsea",
    "of the Silver Marches", "of Myth Drannor", "of Netheril",
    "of the Underdark", "of Icewind Dale", "of Calimshan",
    "of the Dalelands", "of Cormanthor", "of Evermeet",
    # Deity-linked
    "of Mystra's Weave", "of Tempus's Fury", "of Kelemvor's Judgment",
    "of Tyr's Justice", "of Lathander's Dawn", "of Selûne's Light",
    "of Shar's Shadow", "of Bane's Dominion", "of Helm's Vigil",
    "of Tymora's Favor", "of Ilmater's Sacrifice", "of Corellon's Grace",
    "of Moradin's Forge", "of Gruumsh's Wrath", "of Silvanus's Embrace",
    # Events & Ages
    "of the Spellplague", "of the Time of Troubles", "of the Sundering",
    "of the Crown Wars", "of the Fall of Netheril", "of the Dawn Cataclysm",
    "of the Rage of Dragons", "of the Year of Blue Fire",
    "of the Second Sundering", "of the Dracorage",
    # Epic & abstract
    "of the Fallen King", "of Endless Night", "of the Dawn",
    "of Shattered Realms", "of the Iron Throne", "of Lost Souls",
    "of the Phoenix", "of the Deep", "of the Crimson Moon",
    "of Winter's Grasp", "of the Storm Lord", "of the Ancient Pact",
    "of the Forgotten Age", "of the Wild Hunt", "of the Void Walker",
    "of Dragon's Breath", "of the Astral Sea", "of the Blood Oath",
    "of the Eternal Flame", "of Starfall", "of the Last Bastion",
    "of the Shadow Weave", "of Titan's Wrath", "of the Feywild",
    "of the Nine Hells", "of the Arcane Eye", "of the Abyss",
    "of the Elemental Chaos", "of the Far Realm", "of the Shadowfell",
    "of the Fugue Plane", "of the Ethereal Veil",
    # Organization / faction
    "of the Harpers", "of the Zhentarim", "of the Lords' Alliance",
    "of the Emerald Enclave", "of the Order of the Gauntlet",
    "of the Red Wizards", "of the Arcane Brotherhood",
    "of the Cult of the Dragon", "of the Purple Dragon Knights",
    "of the Knights of Myth Drannor", "of the Moonstars",
    "of the Chosen", "of the War Wizards",
  ].freeze

  SIMPLE_SUFFIXES = [
    "of Power", "of Might", "of Valor", "of Grace", "of Fury",
    "of Wisdom", "of Fortune", "of Warding", "of Binding", "of Ruin",
    "of Cunning", "of Glory", "of Resolve", "of Defiance", "of Ambition",
    "of Twilight", "of Storms", "of Shadows", "of Iron", "of Stars",
  ].freeze

  # ── Generate a spectacular name ──
  def self.generate_name(rarity_name, effects, category, weapon = nil)
    prefix = PREFIXES.fetch(rarity_name, PREFIXES["Common"]).sample

    # Category-based title
    cat_name = category.name
    if cat_name == "Weapons" && weapon.present?
      base = weapon
    else
      titles = CATEGORY_TITLES[cat_name]
      base = titles ? titles.sample : cat_name.singularize
    end

    # Effect-based flavor
    primary_effect = effects.max_by(&:power_level) if effects.any?
    flavor = nil
    if primary_effect
      flavors = EFFECT_FLAVOR[primary_effect.effect_type]
      flavor = flavors&.sample
    end

    # Suffix based on rarity
    suffix = case rarity_name
             when "Legendary", "Ancestral"
               SUFFIXES.sample
             when "Very Rare", "Rare"
               rand < 0.6 ? SUFFIXES.sample : SIMPLE_SUFFIXES.sample
             when "Uncommon"
               rand < 0.3 ? SIMPLE_SUFFIXES.sample : nil
             else
               nil
             end

    # Build name: "[Flavor] [Prefix] [Base] [Suffix]"
    parts = []
    parts << flavor if flavor && rand < 0.7
    parts << prefix
    parts << base
    parts << suffix if suffix

    parts.join(" ")
  end

  # ══════════════════════════════════════════════════════
  # DESCRIPTION GENERATION — Deep Faerûn lore
  # ══════════════════════════════════════════════════════

  # ── Legendary smiths & artificers (Faerûn-flavored) ──
  LEGENDARY_SMITHS = [
    "Torvald the Ash-Handed", "Morwen Brightforge", "Kael'thas Ironvein",
    "Sister Elara of the Embers", "the blind dwarf Grundar", "Vaelith the Wandering Artisan",
    "the reclusive gnome Fizzwick", "Master Hendrick of Anvil's Rest",
    "the dragonborn smith Kriv Steelscale", "Orin Half-Giant",
    # Faerûn-specific
    "Durgeddin the Black of Khundrukar", "the Runehammer clan of Citadel Adbar",
    "Gond's chosen artificer Naill Bronzecog", "the azer smiths of the Elemental Plane of Fire",
    "the shadar-kai forgemaster Vaelkith", "High Smith Eldon of Silverymoon",
    "the svirfneblin lapidary Kargien of Blingdenstone", "Master Ilbratha of Evermeet",
    "Clan Ironfist's last runesmith, Thordak", "the human transmuter Arcturia of Halruaa",
    "the shield dwarf Battlehammer forgemasters", "a nameless dao artisan imprisoned beneath Calimshan",
    "the githyanki weapon-singer Tu'narath", "an efreeti bound to a forge of living flame",
    "Tethtoril's apprentice, working in secret beneath Candlekeep",
    "the wild elf bladesinger-smith Elanil Elassidil",
    "the stone giant dreamwalker Kayalithica", "an illithid cerebrex who shaped metal with thought alone",
    "the Netherese arcanist Karsus's last student",
    "the gold dwarf runecaster Thurimar of the Great Rift",
  ].freeze

  # ── Famous wielders ──
  LEGENDARY_WIELDERS = [
    "the paladin Serena Dawnshield", "warlord Thane Drakov",
    "the elven ranger Lirael Starbow", "archmage Verenthos the Unbound",
    "General Kira Stonefist", "the tiefling rogue Malachar",
    "High Priestess Ysolde", "the half-orc champion Grukk Ironjaw",
    "the drow exile Zaelen Nightwhisper", "Sir Aldric of the Silver Dawn",
    "Queen Thessara the Undying", "the monk Haru of the Broken Path",
    # Faerûn-specific (canonical or inspired)
    "Drizzt Do'Urden", "Elminster Aumar", "the Simbul of Aglarond",
    "Khelben 'Blackstaff' Arunsun", "Storm Silverhand",
    "Bruenor Battlehammer", "Wulfgar, son of Beornegar",
    "Catti-brie of Mithral Hall", "Artemis Entreri",
    "Jarlaxle Baenre", "Alias of the Azure Bonds",
    "Dove Falconhand", "Piergeiron the Paladinson",
    "King Gareth Dragonsbane of Damara", "the Raven Queen's champion Havilar",
    "Szass Tam's rival, the lich Larloch", "Manshoon of the Zhentarim",
    "Alustriel Silverhand of Silverymoon", "Danica Maupoissant of the Spirit Soaring",
    "Regis the halfling of Calimport", "Minsc and his miniature giant space hamster",
    "the dragon Klauth, Old Snarl", "Vajra Safahr, the Blackstaff of Waterdeep",
    "an unnamed Knight of the Shield", "the Masked Lord of Waterdeep",
    "the Harper agent known only as 'Twilight'",
    "a Chosen of Mystra whose name was erased from all records",
    "Laeral Silverhand, Open Lord of Waterdeep",
    "Halaster Blackcloak, the Mad Mage of Undermountain",
  ].freeze

  # ── Faerûn locations ──
  LEGENDARY_PLACES = [
    "the Forge of Falling Stars", "Mount Pyratheon's caldera",
    "the Sunken Temple of Vel'koz", "the Crystalline Caverns of Aethon",
    "the ruins of the Sky Citadel", "the Abyssal Rift of Xar'nath",
    "the Feywild crossing at Moonhollow", "the Dragonbone Wastes",
    "the Frozen Throne of Ithkar", "the Whispering Observatory",
    "the Tomb of the First Emperor", "the Living Dungeon of Morpheus",
    # Faerûn-specific
    "Mithral Hall beneath the Spine of the World",
    "the Hosttower of the Arcane in Luskan",
    "the ruins of Myth Drannor in Cormanthor",
    "the Floating City of Thultanthar before its fall",
    "the depths of Undermountain beneath Waterdeep",
    "Candlekeep's forbidden lower vaults",
    "the Grandfather Tree in the High Forest",
    "the black pits of Menzoberranzan",
    "the caldera of Mount Hotenow near Neverwinter",
    "the Netherese ruins of Ascore in the Anauroch",
    "the Walking Statues' foundry beneath Waterdeep",
    "the Crystal Shard's resting place in Icewind Dale",
    "the Sumber Hills elemental nodes",
    "the elven ruins of Eaerlann",
    "Citadel Adbar's deepest forge hall",
    "Gauntlgrym, the ancient dwarven city rediscovered",
    "the dragonborn enclave of Tymanther",
    "the Thayan plateau where the Dread Ring was raised",
    "the Moonwell of the Misty Forest",
    "Evermeet, across the Trackless Sea",
    "the petrified dragon graveyard of the Mere of Dead Men",
    "the Well of Dragons in the Sunset Mountains",
    "a hidden demiplane accessible only through Sigil's portals",
    "the Fountains of Memory in Silverymoon",
    "the subterranean Lake of Shadows beneath Blingdenstone",
    "the cloud giant fortress of Lyn Armaal",
    "the fire giant forge of Ironslag",
    "the aboleth city of Xxiphu, pulled from the Far Realm",
  ].freeze

  # ── Major events of Faerûn ──
  LEGENDARY_EVENTS = [
    "the Siege of Ashenmoor", "the Night of Falling Stars",
    "the Sundering of the Veil", "the War of Broken Crowns",
    "the Dragon Conclave of the Third Age", "the Plague of Shadows",
    "the Great Convergence", "the Betrayal at Silver Gate",
    "the Battle of the Bleeding Fields", "the Eclipse of Empires",
    "the Pact of Eternal Flame", "the Cataclysm of the Weeping God",
    # Faerûn-specific
    "the Time of Troubles, when gods walked Toril as mortals",
    "the Spellplague that ravaged the Weave",
    "the fall of Netheril and the death of Karsus",
    "the Crown Wars that shattered the elven empires",
    "the Second Sundering that reshaped the world",
    "the Rage of Dragons that burned a hundred cities",
    "the Dracorage that drove wyrms to madness",
    "the Goblin Wars of the Silver Marches",
    "the Rise of the Cult of the Dragon",
    "the Darkening over the Silver Marches",
    "Mystra's assassination at the hands of Cyric and Shar",
    "the invasion of Thay's undead legions",
    "the destruction of Zhentil Keep",
    "the siege of Mithral Hall by drow forces",
    "the eruption of Mount Hotenow that devastated Neverwinter",
    "the Tyranny of Dragons, when Tiamat nearly returned",
    "the elemental cults' assault on the Dessarin Valley",
    "the demon lords' incursion into the Underdark",
    "the death curse of Acererak that plagued the Sword Coast",
    "the Blood War's spillover into the mortal realm",
    "the ancient war between Bahamut and Tiamat",
    "Larloch's attempted apotheosis in the ruins of Warlock's Crypt",
    "the founding of Luruar, the Silver Marches confederation",
    "the Zhentarim's bloody consolidation of the Black Road trade routes",
  ].freeze

  # ── Forgotten Realms deities for flavor ──
  DEITIES = [
    "Mystra, goddess of magic", "Tempus, god of war", "Tyr, god of justice",
    "Kelemvor, god of the dead", "Lathander, god of the dawn",
    "Selûne, goddess of the moon", "Shar, goddess of darkness",
    "Bane, god of tyranny", "Helm, god of protection",
    "Tymora, goddess of luck", "Ilmater, god of suffering",
    "Corellon Larethian, creator of the elves", "Moradin, the All-Father of dwarves",
    "Gruumsh, the one-eyed god of orcs", "Silvanus, god of wild nature",
    "Chauntea, goddess of agriculture", "Oghma, god of knowledge",
    "Gond, god of craft and invention", "Mask, god of thieves",
    "Cyric, the Prince of Lies", "Sune, goddess of beauty and love",
    "Bahamut, the Platinum Dragon", "Tiamat, the Dragon Queen",
    "Lolth, the Spider Queen", "Mielikki, goddess of forests",
    "Waukeen, goddess of trade", "Talos, god of storms",
    "Auril, goddess of winter", "Umberlee, goddess of the sea",
    "Savras, god of divination and fate", "Azuth, patron of wizards",
    "Deneir, god of writing and glyphs", "the Raven Queen",
  ].freeze

  # ── Faerûn organizations ──
  ORGANIZATIONS = [
    "the Harpers", "the Zhentarim, the Black Network",
    "the Lords' Alliance", "the Emerald Enclave",
    "the Order of the Gauntlet", "the Red Wizards of Thay",
    "the Arcane Brotherhood of Luskan", "the Cult of the Dragon",
    "the Purple Dragon Knights of Cormyr", "the Knights of Myth Drannor",
    "the Moonstars", "the Chosen of Mystra",
    "the War Wizards of Cormyr", "the Shadow Thieves of Amn",
    "the Flaming Fist mercenary company", "the Bregan D'aerthe",
    "the Church of Shar's Dark Moon monks", "the Watchful Order of Magists and Protectors",
    "the Xanathar Thieves' Guild of Waterdeep", "the Force Grey of Waterdeep",
    "House Baenre of Menzoberranzan", "the Council of Mages of Halruaa",
    "the Bedine nomads of the Anauroch", "the druids of the Moonshae Isles",
  ].freeze

  # ── Races, cultures, materials ──
  EXOTIC_MATERIALS = [
    "adamantine mined from the deepest veins of the Underdark",
    "mithral from the legendary deposits of Mithral Hall",
    "darksteel forged in the Shadowfell's perpetual twilight",
    "glassteel, as transparent as crystal and harder than diamond",
    "star metal harvested from a fallen fragment of the Tears of Selûne",
    "dragonfang bone, taken from an ancient wyrm's jawbone",
    "a shard of raw Weave crystallized during the Spellplague",
    "residuum, the powdered remains of deconstructed magical artifacts",
    "moonstone infused with Selûne's tears during a lunar eclipse",
    "living wood from the Grandfather Tree of the High Forest",
    "ice that never melts, taken from the heart of the Great Glacier",
    "the heartstone of a night hag, willingly surrendered",
    "a scale willingly given by an ancient gold dragon",
    "iron from the Nine Hells, quenched in the River Styx",
    "coral from the drowned city of Ascarle beneath the Trackless Sea",
    "obsidian from the Elemental Plane of Fire, still warm to the touch",
    "a fragment of crystallized time from the Temporal Prime",
    "feywild silver that changes hue with the bearer's emotions",
    "astral driftmetal collected from dead gods floating in the Silver Void",
    "primordial essence trapped in amber since before the Dawn War",
    "ironwood blessed by the druids of the Emerald Enclave",
    "a thread of spider silk from Lolth's own domain in the Demonweb Pits",
    "the petrified heartwood of a treant elder, freely given in its final season",
    "voidstone recovered from the wreckage of a Netherese flying city",
  ].freeze

  AGES_AND_ERAS = [
    "the Days of Thunder, when creator races ruled Toril",
    "the First Flowering, the golden age of the elven empires",
    "the Crown Wars, when elf fought elf for supremacy",
    "the Founding Time, when humans first built lasting civilizations",
    "the age of Netheril, the greatest human magical empire",
    "the Fall of Netheril, when Karsus's hubris ended an age",
    "the Era of Upheaval, when gods walked the Realms",
    "the years following the Spellplague, when magic itself went mad",
    "the Second Sundering, when the world was reforged",
    "the Sundering of the Tablets of Fate",
    "the founding of Waterdeep, the City of Splendors",
    "the drow descent into the Underdark after the Crown Wars",
    "the reign of the Shoon Imperium in the south",
    "the rise of Cormyr under House Obarskyr",
  ].freeze

  CURSES_AND_QUIRKS = [
    "it is said to bring terrible misfortune upon any who steal it, though those who earn it find the opposite",
    "once per century it vanishes from its owner's possession and reappears somewhere else entirely, as if compelled to seek a new chapter in its story",
    "prolonged possession slowly changes the bearer's eye color to an unnatural silver",
    "the item is rumored to have a twin, forged at the same time, and the two are said to resonate when brought near each other",
    "it cannot be wielded by anyone of evil intent — it simply becomes too heavy to lift",
    "it occasionally speaks a single word in a dead language, always at the most inconvenient moment",
    "those who have died while carrying it report seeing its likeness in the Fugue Plane, watching them from the mists",
    "it is warm to the touch of the worthy and freezing cold to everyone else",
    "scrying magic cannot locate it — the item simply does not appear on the Weave's tapestry",
    "it weighs nothing on moonless nights and twice as much during a full moon, as though Selûne herself has a claim on it",
    "anyone who holds it for more than a day begins to understand Draconic, even if they have never heard it spoken",
    "it leaves behind a faint scent of petrichor, as though rain has recently fallen wherever it has been",
    "divination spells cast near it occasionally reveal scenes from its past instead of the intended target",
    "it slowly repairs itself if damaged, drawing on ambient magical energy — the process takes exactly one tenday",
    "the item is invisible to creatures of the Shadowfell, passing through their perception like a ghost",
    "songbirds are drawn to its presence; at least one will appear within minutes of it being uncovered",
    "it hums a different note for each school of magic used nearby, creating an unintentional melody during battles",
  ].freeze

  PROPHECIES = [
    "Alaundo's prophecies mention an item matching its description, foretelling it will be present 'when the stars weep and the world holds its breath.'",
    "A verse in the Nether Scrolls describes a relic of this nature as 'the lock upon a door that must never be opened — or the key, depending on the age.'",
    "Seers of Savras have independently produced visions of this item throughout the centuries, always in the hands of someone standing at a crossroads of fate.",
    "The Harpers maintain a sealed dossier on this artifact, updated every generation by a different agent. The file is thicker than most histories.",
    "Candlekeep's Index of Artifacts lists it under three different names, each corresponding to a different age. The monks suspect it changes its identity as deliberately as a spy.",
    "An ancient prophecy of the Uthgardt tribes speaks of 'the weapon that remembers' — their shamans claim this is the item those words describe.",
    "The Red Wizards of Thay have offered a standing bounty for information about this item for over two centuries. They have never explained why.",
    "A passage in Volo's Guide (later editions excised it at Elminster's insistence) cryptically warns: 'seek it not unless you can bear the weight of what it knows.'",
  ].freeze

  # ── Origins per rarity — massively expanded ──
  ORIGINS = {
    "Common" => [
      "Crafted by a village smith as part of a modest commission.",
      "Assembled from quality materials by a traveling artisan.",
      "Produced in a guild workshop following time-tested methods.",
      "Fashioned during a quiet winter by a seasoned craftsperson.",
      "Bought from a market stall in a busy trade town, its previous owner unknown.",
      "Salvaged from an abandoned outpost and restored with care.",
      "Made by a Waterdhavian apprentice as their journeyman's proof — functional, reliable, unspectacular.",
      "Forged in the Trades Ward of Waterdeep by one of the lesser guild smiths.",
      "Purchased from a caravan merchant traveling the Trade Way between Baldur's Gate and Amn.",
      "Crafted in Neverwinter, once known for its skilled artisans before the eruption.",
      "Assembled from salvaged materials after a Zhentarim supply wagon was raided along the Black Road.",
      "Produced in the workshops beneath Citadel Felbarr, deemed too mundane for dwarven use but perfectly suitable for human hands.",
    ],
    "Uncommon" => [
      "Forged under a blood moon by an apprentice who exceeded their master's expectations.",
      "Discovered in a collapsed merchant caravan along the Silver Road.",
      "Created by a retired adventurer who wove a fragment of their experience into the craft.",
      "Blessed by a wandering cleric in exchange for shelter during a terrible storm.",
      "Recovered from the hoard of a young dragon that had only begun to collect treasures.",
      "Won in a tournament of skill where the prize was said to bring luck to its bearer.",
      "Found half-buried in the aftermath of a skirmish between rival adventuring companies.",
      "Commissioned by a minor noble as a gift for a loyal retainer, but it never reached its intended owner.",
      "Imbued with minor enchantments by a Harper agent who needed a reliable tool in a hurry.",
      "Traded by a Calishite merchant who swore it was blessed by a djinni — for once, the merchant told the truth.",
      "Crafted in Silverymoon's Vault of the Sages as a teaching exercise; the student's work surpassed expectations.",
      "Found in the belly of a displacer beast by a startled ranger in the Cloakwood.",
      "Enchanted by a wild magic sorcerer during a surge — the result was unexpectedly practical.",
      "Recovered from a Zhentarim safehouse in Daggerford after the Black Network abandoned the position.",
      "Discovered among the possessions of a deceased member of the Order of the Gauntlet, bequeathed to whoever would carry on their work.",
    ],
    "Rare" => [
      "Forged in the crucible of a war between two rival mage guilds, its enchantments a byproduct of their fierce competition.",
      "Plucked from the dreams of a sleeping archmage by a daring planar thief.",
      "Crafted by dwarven runesmiths deep within the Undermountain, quenched in water from an underground lake that glows with bioluminescent fungi.",
      "Recovered from the tomb of a forgotten general whose conquests once reshaped the borders of three kingdoms.",
      "Imbued with power during a rare celestial alignment that occurs only once every century.",
      "Salvaged from the wreckage of a spelljammer that crashed into the Sea of Fallen Stars, still humming with residual astral energy.",
      "Forged by %{smith} during a fevered three-day vision quest, the design revealed by a spirit of the forge.",
      "Discovered inside a geode of pure arcane crystal in the Underdark, as if the stone had grown around it over millennia.",
      "Enchanted in the spire of the Hosttower of the Arcane in Luskan, before the Arcane Brotherhood's latest downfall.",
      "Created from %{material}, worked by %{smith} under the light of a Moonwell in the Misty Forest.",
      "Recovered from the ruins of a Netherese outpost half-buried in the sands of the Anauroch, its enchantments somehow preserved across millennia.",
      "Forged during %{era} and passed through dozens of hands before disappearing from recorded history — until now.",
      "Found in a sealed chamber beneath Gauntlgrym, alongside a journal describing its creation in a language that predates Common.",
      "Crafted by the azer smiths in the City of Brass at the request of a mortal who won a contest of riddles with an efreeti noble.",
      "Woven with magic by a circle of druids in the Emerald Enclave, who shaped it over the course of a full year, each season contributing a different property.",
      "Pulled from the petrified grip of a medusa's victim in the depths of the Mere of Dead Men — the victim was an adventurer of some renown, and the item outlasted them.",
    ],
    "Very Rare" => [
      "Forged in the heart of a dying star by an astral smith who bargained with the fabric of reality itself. The metal still carries the faint warmth of stellar fire.",
      "Pulled from the petrified hand of an ancient hero whose statue has stood at a crossroads for a thousand years, slowly accumulating ambient magic from every spell cast nearby.",
      "Created during the Sundering, when the barriers between planes thinned and raw magical energy flooded the mortal realm. Its creator sacrificed their sight to complete the work.",
      "Assembled from fragments of three legendary artifacts, each destroyed in a different age. The echoes of their former power resonate within this new form.",
      "Born from the last breath of a phoenix that chose not to be reborn, pouring its eternal flame into mortal craft instead.",
      "Shaped by %{smith} in %{place}, where the boundary between the Material Plane and the Shadowfell is thin as parchment. Shadows still cling to its surface when the light is right.",
      "This artifact was the spoils of %{event}. %{wielder} claimed it from the battlefield, though some say it chose its bearer rather than the other way around.",
      "Grown — not forged — in a garden tended by archfey, where metal blooms like flowers and gems ripen on crystalline vines. The process took seven mortal lifetimes.",
      "Forged in Gauntlgrym's Great Forge, fueled by the bound primordial Maegera. The fire of a trapped god burns within it — a fact that the dwarves do not advertise.",
      "Created from %{material}, shaped during %{event} by %{smith}. It carries the memory of that day like a scar — or a badge of honor.",
      "Recovered from the Tomb of Horrors by one of the few adventurers to survive Acererak's gauntlet. The demilich allowed them to leave with it, which may be more troubling than if he had not.",
      "Pulled from the Weave itself by a Chosen of Mystra, given physical form through an act of will that cost the Chosen a century of their lifespan.",
      "Crafted beneath the waves of the Trackless Sea in the sahuagin city of Vahadar, using techniques unknown to surface-dwellers. How it came to land is a mystery the sea-devils would kill to know.",
      "Assembled during a conjunction of Selûne and her Tears by the priestesses of the Moonmaiden, each component blessed by a different aspect of the goddess.",
      "Forged in the volcano beneath the Well of Dragons, its metal cooled in the blood of a dragon willingly given. The chromatic and metallic factions both claim credit, which tells you everything.",
    ],
    "Legendary" => [
      "Forged in dragonfire by the last of the Titan-smiths, this artifact was meant to seal a rift between the mortal world and the Abyss. When the rift closed, the item remained — forever touched by the darkness it contained. Kingdoms have risen and fallen in wars fought over its possession.",
      "Legend holds that a god walked the mortal realm disguised as a beggar and, moved by an act of extraordinary kindness, left this item behind as a gift. Those who have carried it report hearing whispers of divine guidance in their darkest hours, though the god has never returned to claim it.",
      "This artifact was the final work of %{smith}, who spent forty years gathering materials from every known plane of existence. Upon completing it, they vanished without a trace. Some say the item consumed them; others believe they ascended to a higher plane of existence.",
      "Carved from the heartwood of the World Tree by elven artificers during the First Age, this item has witnessed the rise and fall of every civilization since. Its surface bears the scratches and marks of countless battles, each one a chapter in the story of the world.",
      "Created during %{event}, when the gods themselves took up arms. %{wielder} wielded it as a mortal champion chosen by fate to fight alongside divine beings. It absorbed fragments of godly power with each blow struck in that cosmic conflict.",
      "Recovered from %{place} by %{wielder}, who spent a decade navigating the deadly traps and ancient guardians that protected it. The expedition cost the lives of thirty companions. The survivor emerged changed — older, wiser, and bound to the artifact by something deeper than ownership.",
      "Seven archmages pooled their life force to create this artifact during %{event}. Each mage died upon completing their contribution, their final thoughts and memories crystallized within the enchantment. The item sometimes speaks with their voices.",
      # Deep Faerûn lore
      "This item was present when Mystra was murdered during the Time of Troubles, and it absorbed a fragment of divine power as the goddess fell. The Weave itself shuddered, and a sliver of its fabric became permanently woven into this object. Elminster himself has examined it and refused to say what he found.",
      "Forged by Moradin in the foundry of Dwarfhome and gifted to the first king of Shanatar. It passed through every great dwarven kingdom — Oghrann, Gharraghaur, Iltkazar — before the fall of Shanatar scattered it to the winds. Dwarves who see it weep, though they cannot explain why.",
      "Created by a circle of seven Chosen of Mystra during the Era of Upheaval, each contributing a different aspect of the Weave. Midnight herself (Mystra reborn) is said to have blessed it, though the new goddess of magic is enigmatic about confirming such stories.",
      "This artifact surfaced in %{place} after %{event}. %{wielder} carried it for a time, but ultimately left it behind, writing in their journal: 'It has done what it came to do through me. I am merely the latest in a long line.' The journal is preserved in Candlekeep.",
      "Wrought from %{material} by %{smith} during %{era}. The creation process required the voluntary sacrifice of a celestial, whose essence was bound into the metal. On quiet nights, the item radiates a warmth that has nothing to do with temperature — it is the last echo of an angel's compassion.",
      "This is one of the Twelve Tears of Selûne — artifacts said to have fallen to Toril when the goddess wept for the suffering of the mortal world. Only four have ever been found. The others are the subject of ceaseless quests by the Selûnite faithful.",
    ],
    "Ancestral" => [
      "This artifact predates the gods themselves. Ancient texts speak of it as a fragment of the primordial force that shaped reality — a sliver of pure creation given form. It existed before language, before thought, before the first star ignited in the void. Those who hold it feel the weight of eternity pressing against their consciousness, the echo of a universe being born.",
      "Woven from the threads of fate by the Three Sisters who sit beyond time itself, this item was placed in the mortal world as a test — or perhaps a gift. Every prophecy ever spoken references it obliquely, and every great turning point in history can be traced back to its influence. It does not merely exist within destiny; it IS destiny made manifest.",
      "Born in the space between heartbeats of the Sleeping God, forged from the boundary between existence and oblivion. When the universe was young and formless, this item crystallized from the first act of will — the moment consciousness emerged from chaos. Scholars who study it too closely report that the boundaries of their own reality begin to blur.",
      "The oldest beings in existence — the primordial dragons, the elder elementals, the first fey — all remember a time when this item was already ancient. It carries within it the memory of a universe that existed before this one, a cosmos that collapsed so that ours might be born. To wield it is to touch infinity.",
      "Created at the exact moment the multiverse came into being, this artifact is simultaneously the first and last thing that will ever exist. Time flows differently in its presence. Heroes who have carried it describe experiencing their entire lifetime in a single breath, only to find that centuries have passed in the outside world.",
      "The concept of this artifact exists in every reality simultaneously. In each universe, a version manifests differently, but the core essence — the primordial spark of creation — remains identical. Sages theorize that if every version were brought together, reality itself would fold inward. None have dared attempt it.",
      # Deep cosmological Faerûn lore
      "This item was forged in the Days of Thunder, before the humanoid races walked Toril. The creator races — the sarrukh, the batrachi, the aearee — shaped it from materials that no longer exist in the natural world. It passed through the hands of the Imaskari, the Netherese, the elves of Aryvandaar, and countless others. Each civilization added to its enchantment before falling to dust, and each civilization's greatest achievement lives on within it.",
      "When Ao the Overgod created the crystal sphere of Realmspace, a fragment of his will became embedded in the fabric of Toril. This is that fragment, given physical form by forces that predate even the primordials. Ao has never acknowledged its existence, which some theologians interpret as the most significant statement of all.",
      "This artifact was present at the casting of Karsus's Avatar — the only 12th-level spell ever cast — and survived the resulting catastrophe that killed Mystryl and destroyed Netheril. It absorbed a fragment of the original Weave as Mystryl died, and within it lives a sliver of magic as it existed before the current Mystra imposed her restrictions. Wizards who attune to it describe accessing 'a deeper layer' of the Weave — one that Mystra herself may not control.",
      "Forged by the primordials during the Dawn War against the gods, this weapon was created to unmake divine power itself. When the gods won, they could not destroy it — the act of unmaking the Unmaker would have paradoxically empowered it. Instead, they sealed it away in a prison of layered demiplanes, each one more impenetrable than the last. It escaped. It always escapes.",
      "The Nether Scrolls — the most powerful magical artifacts on Toril — reference this item not as a creation but as a constant, like gravity or the passage of time. The scrolls describe it as 'that which was before us, which will be after us, which exists in the spaces between our words.' Even the phaerimm, who corrupted the scrolls, left these passages untouched. They were afraid to alter them.",
      "Created during the Tearfall, when the world was young and the barriers between planes had not yet hardened. It is part artifact, part living spell, part divine thought — the categories blur when examining something this ancient. The last mortal to fully comprehend its nature was the Netherese arcanist Ioulaum, and the knowledge drove him to become an elder brain in a desperate attempt to expand his cognition enough to contain what he had learned.",
    ],
  }.freeze

  # ── Rich effect narrative fragments — expanded ──
  EFFECT_DESCRIPTIONS = {
    "Attack Bonus" => [
      "guides strikes with supernatural precision, as if an invisible hand corrects the arc of every swing",
      "hones the wielder's combat instincts to a razor edge — strikes land where the eye cannot follow",
      "bends probability to favor deadly accuracy; opponents speak of blows that arrive before they can react",
      "whispers targeting adjustments directly into the wielder's muscle memory",
      "channels the battle-wisdom of a hundred dead warriors, each one guiding the blade to its mark",
      "resonates with the precision of Tempus himself — every strike finds the gap in armor, the weakness in the guard",
    ],
    "Attack Damage" => [
      "amplifies the destructive force of every blow, turning glancing hits into devastating wounds",
      "channels raw elemental fury into each strike — the air itself screams on impact",
      "tears through defenses with devastating power, leaving wounds that resist magical healing",
      "unleashes concussive bursts of force that echo through armor and bone alike",
      "strikes with the fury of a storm giant's hammer, the impact rippling outward in visible shockwaves",
      "delivers blows that resonate on multiple planes simultaneously — the target is damaged in body, mind, and spirit",
    ],
    "Defense" => [
      "creates an invisible barrier that deflects incoming harm, shimmering faintly when struck",
      "hardens the air around the bearer into a shimmering ward that reacts faster than thought",
      "absorbs the kinetic force of attacks before they land, dispersing the energy as harmless light",
      "projects a lattice of protective runes that flare to life when danger approaches",
      "surrounds the bearer in a shell of force reminiscent of the shields projected by the War Wizards of Cormyr",
      "weaves a defense drawn from the Weave itself — Mystra's fabric turned into a physical bulwark",
    ],
    "Healing" => [
      "mends wounds with warm, golden light that smells faintly of spring rain",
      "accelerates the body's natural recovery, knitting torn flesh and mending broken bone in moments",
      "draws on ambient life energy to restore vitality, leaving the surrounding grass greener and flowers taller",
      "pulses with a gentle heartbeat-like rhythm that synchronizes with the bearer's own, slowly washing away pain and fatigue",
      "channels the compassion of Ilmater, easing suffering with a warmth that goes beyond the physical",
      "heals with the same restorative power as water from the legendary Moonwells of the Misty Forest",
    ],
    "Material" => [
      "is wrought from a substance that defies conventional metallurgy — it is lighter than steel yet harder than adamantine",
      "incorporates materials from beyond the mortal realm, their properties shifting subtly with the phases of the moon",
      "resonates with the inherent magic of its exotic components, each one gathered from a different plane of existence",
      "was crafted from ore that fell from the sky during a meteor shower, still carrying trace amounts of stellar energy",
      "is fashioned from %{material}, a substance that even the most learned sages struggle to classify",
      "bears the unmistakable hallmarks of Underdark craftsmanship — light as a whisper, hard as the stone that birthed it",
    ],
    "Stealth" => [
      "bends light and sound around the bearer, making them little more than a suggestion in the corner of one's eye",
      "wraps the user in a cloak of silence and shadow — even dogs lose the scent",
      "makes the bearer nearly invisible to mundane senses; only the most perceptive notice a faint distortion, like heat rising from summer stone",
      "absorbs the bearer's footfalls, breath, and even heartbeat into an envelope of absolute stillness",
      "grants the shadow-walking abilities once reserved for Mask's chosen — the bearer moves between shadows as naturally as walking through doorways",
      "cloaks the wearer as thoroughly as a drow assassin of Bregan D'aerthe, erasing their presence from all but magical detection",
    ],
    "Speed" => [
      "quickens the bearer's movements to a blur — witnesses describe a streak of color where a person should be",
      "lets the user move as if gravity were merely a suggestion, each stride covering impossible ground",
      "grants bursts of preternatural swiftness that can outpace an arrow in flight",
      "bends time slightly around the bearer, giving them an extra heartbeat to react when others would freeze",
      "channels the speed of Shaundakul's winds, letting the bearer move as fast as thought",
      "grants the swiftness of a phase spider, blurring between here and the Ethereal to cover impossible distances",
    ],
    "Protection" => [
      "wards against magical and mundane threats alike, turning aside blade and spell with equal ease",
      "projects an aura of safety that turns aside danger — arrows veer, spells fizzle, and blades skid along invisible curves",
      "shields the bearer with ancient protective sigils that activate independently, each one guarding against a different school of harm",
      "creates a sanctuary of calm within chaos; allies standing near the bearer report feeling unnaturally safe, as if the world's dangers simply forget they exist",
      "radiates the protective blessing of Helm, the Vigilant One — an unsleeping guardian forged into physical form",
      "invokes the ancient wards of Myth Drannor, layered protections that once shielded an entire city of mages",
    ],
    "Resistance" => [
      "fortifies the bearer against hostile energies, turning lethal forces into mild discomfort",
      "renders the user resilient to forces that would break lesser beings, shrugging off attacks that should be fatal",
      "provides enduring protection against specific forms of harm — the enchantment learns from each assault, growing stronger with experience",
      "grants the legendary resilience of the Ironlord barbarians of Rashemen, whose fury renders them nearly impervious to harm",
      "shields the bearer as completely as a sphere of invulnerability, though with more finesse and none of the limitations",
    ],
    "Conjuration" => [
      "opens brief portals to other planes of existence, through which glimpses of alien landscapes flash",
      "can summon objects or creatures from distant realms, drawn by the bearer's focused will",
      "bends the fabric of space to bring forth what is needed, though the portals occasionally admit things that were not invited",
      "rips holes in reality with the precision of a War Wizard's teleportation circle — efficient, reliable, and deeply unsettling to witness",
      "draws upon the same planar energies that power the portals of Sigil, the City of Doors",
    ],
    "Flight" => [
      "grants the gift of soaring through the skies, carried on wings of shimmering force",
      "defies gravity at the bearer's command, allowing movement in three dimensions as naturally as walking",
      "lifts the user on currents of magical force, leaving a trail of faintly glowing motes in their wake",
      "bestows the effortless flight of an aarakocra, the sky becoming as familiar as solid ground",
      "harnesses the winds of the Elemental Plane of Air, granting flight as swift and maneuverable as a dragon's",
    ],
    "Frosting" => [
      "radiates an aura of bitter, biting cold that turns breath to fog and water to ice within arm's reach",
      "sheaths itself in a layer of never-melting ice, cold enough to numb on contact",
      "can freeze the very moisture from the air, creating walls, bridges, or prisons of crystalline ice at the bearer's command",
      "channels the eternal winter of Auril's domain, coating everything nearby in creeping frost",
      "radiates the bitter cold of Icewind Dale — the kind of cold that kills silently and without mercy",
    ],
    "Lightning" => [
      "crackles with barely contained electrical fury — the bearer's hair stands on end, and small objects levitate nearby",
      "calls down bolts of lightning at the wielder's command, each one leaving the acrid taste of ozone",
      "channels the raw power of the storm, arcing between enemies with calculated, devastating precision",
      "thunders with the voice of Talos the Stormlord, each discharge a miniature tempest",
      "stores electrical energy like a living capacitor, discharging it with the devastating precision of a blue dragon's breath",
    ],
    "Vision" => [
      "reveals what is hidden from ordinary sight — invisible creatures shimmer, illusions dissolve, and the truth stands naked",
      "grants perception that pierces illusion and darkness, extending sight into the ethereal plane",
      "opens the bearer's eyes to truths beyond mortal ken; some who use it report seeing the threads of fate that bind all living things",
      "bestows the all-seeing perception of Savras, god of divination — nothing hidden, nothing obscured, nothing unknown",
      "grants truesight sharper than a beholder's central eye, piercing every veil and penetrating every disguise",
    ],
    "Luck" => [
      "subtly tilts fortune in the bearer's favor — coins land heads-up, dice roll high, and traps misfire at critical moments",
      "seems to attract fortunate coincidences: doors left unlocked, guards looking the wrong way, storms clearing just in time",
      "bends probability in small but meaningful ways; over time, the cumulative effect is like having an invisible guardian angel",
      "carries the blessing of Tymora herself — Lady Luck smiles on whoever bears this item",
      "radiates the kind of impossible fortune that Halflings call 'the knack' — a supernatural talent for being in exactly the right place",
    ],
    "Control" => [
      "grants dominion over the will of others, bending minds like a blacksmith bends iron",
      "allows the wielder to bend minds to their purpose — the affected rarely realize their thoughts are not their own",
      "exerts an irresistible force of command; even those who resist report a crushing weight of authority pressing against their consciousness",
      "wields psychic influence as refined as a mind flayer elder brain's, but without the malice — or perhaps with a different kind",
      "channels the commanding presence of Bane, the Black Lord — obedience is not requested, it is assumed",
    ],
    "Minding" => [
      "resonates with the thoughts of those nearby, creating a web of awareness that extends in every direction",
      "expands the bearer's mental reach far beyond normal limits, touching minds miles away",
      "creates a psychic link between the wielder and the world around them; animals, plants, and even stones whisper their secrets",
      "opens the bearer's mind to the Underdark's psionic currents — the psychic background radiation that mind flayers navigate as easily as breathing",
      "connects the wielder to the collective unconscious of Toril, the deep well of thought that every sentient being contributes to",
    ],
    "Summoning" => [
      "can call forth loyal servants from other planes of existence, bound by ancient pacts older than mortal memory",
      "binds extraplanar beings to temporary service — they come willingly, drawn by the artifact's reputation among the outer planes",
      "opens channels to realms populated by willing allies; the summoned creatures speak of the artifact with reverence",
      "draws servants from across the planes as a lighthouse draws ships — beings of all types respond to its call",
      "commands the loyalty of extraplanar beings through ancient pacts inscribed in the language of the creator races",
    ],
    "Enhance" => [
      "amplifies the bearer's natural abilities beyond mortal limits — a strong warrior becomes a titan, a quick rogue becomes a phantom",
      "infuses the body and mind with surges of magical energy that sharpen every sense and multiply every strength",
      "pushes physical and mental capabilities to their absolute peak, then beyond; the experience is described as briefly touching the divine",
      "grants an enhancement reminiscent of the legendary might of Bhaal's Chosen — raw, transcendent power flowing through mortal flesh",
      "elevates the bearer to the cusp of divinity, granting abilities that blur the line between mortal and god",
    ],
    "Utility" => [
      "provides a versatile array of practical magical functions that adapt to the situation at hand",
      "adapts to serve whatever need the moment demands — a tool, a shelter, a light in darkness",
      "contains a wellspring of useful enchantments, each one activating intuitively when the need arises",
      "offers the kind of resourceful magic that the Harpers value most — subtle, practical, and endlessly adaptable",
      "functions with the versatile precision of a Gondsman's finest invention, solving problems its creator never anticipated",
    ],
    "Understanding" => [
      "bridges the gap between all languages and forms of communication, including the silent speech of animals and the slow language of trees",
      "opens the mind to comprehend any spoken or written word, from ancient dead tongues to the mathematical language of the universe itself",
      "grants intuitive understanding of meaning beyond mere words — the bearer can read intent, deception, and emotion as easily as text on a page",
      "bestows the comprehension of Deneir, god of glyphs and writing — every written word and spoken tongue becomes as clear as the bearer's mother language",
    ],
    "Absortion" => [
      "hungrily devours hostile magic directed at the bearer, converting it into raw energy that crackles across its surface",
      "converts incoming magical energy into usable power, growing visibly brighter with each spell it absorbs",
      "creates a void that swallows spells before they can take effect — enemy casters describe the sensation as trying to light a fire underwater",
      "absorbs magical energy with the insatiable hunger of a phaerimm, converting hostile spells into stored power",
      "drinks in the Weave the way parched earth drinks rain — every spell cast at the bearer feeds the artifact's reserves",
    ],
    "Saving Throws" => [
      "bolsters the bearer's will and constitution against harmful effects, as though an invisible shield guards the mind and body",
      "provides the unyielding mental fortitude of a mind blank spell, protecting against the most insidious effects",
    ],
    "Initiative" => [
      "sharpens the bearer's reflexes to supernatural levels, ensuring they act before danger can materialize",
      "grants the combat awareness of a seasoned Bladesinger — the bearer moves first, always",
    ],
    "Inmunity" => [
      "grants absolute protection against specific forms of harm, as if the damaging force simply ceases to exist upon contact",
      "renders the bearer utterly impervious to a particular type of energy, the way a salamander is immune to flame",
    ],
  }.freeze

  # ── Personality traits — expanded ──
  PERSONALITY_TRAITS = [
    "It hums faintly when danger is near, the pitch rising as the threat grows closer.",
    "It grows warm to the touch during moments of great emotion, as if sharing in its bearer's feelings.",
    "Those who carry it dream of places they have never been — ancient cities, alien landscapes, the spaces between stars.",
    "It seems to resist being put down, growing subtly heavier when set aside, as if it fears abandonment.",
    "It glows faintly in the presence of the undead, the light carrying a color that has no name in any mortal language.",
    "Animals react to it with unease — or unusual affection. Dogs howl, cats purr, and birds land on the bearer's shoulders.",
    "It smells faintly of ozone after being used, a crackling scent that lingers for hours.",
    "Those nearby occasionally hear the distant sound of bells, though no bell tower stands for miles.",
    "It leaves a faint trail of sparks when swung through the air, each one a different color.",
    "Flowers bloom more quickly in its presence, turning to face it like sunflowers tracking the sun.",
    "Its weight seems to change with the phases of the moon — featherlight during the new moon, impossibly heavy during the full.",
    "It occasionally whispers fragments of forgotten languages, as if rehearsing memories that are not its own.",
    "Water near it develops a faint iridescent sheen, and tea brewed in its presence tastes faintly of honey.",
    "It casts no shadow, even in direct sunlight — or perhaps it casts a shadow of something else entirely.",
    "Flames flicker toward it as if drawn by an invisible current, and campfires burn longer in its proximity.",
    "Inscriptions on its surface seem to shift and rearrange when not observed, telling different stories each time they are read.",
    "Compasses behave erratically in its presence, their needles spinning before pointing stubbornly toward the artifact.",
    "The bearer's reflection appears slightly different in mirrors — older, younger, or wearing unfamiliar armor.",
    "Touching it for the first time triggers a vivid flash of memory that does not belong to the bearer — a fragment of a previous owner's life.",
    "It vibrates with a deep, subsonic pulse during thunderstorms, as if answering a call from the sky.",
    "Detect magic reveals it burns brighter than it should — far brighter, as if it contains a compressed sun of magical energy.",
    "It resonates with a barely audible chord when brought near other magical items, as though cataloguing the enchantments around it.",
    "The temperature around it is always exactly comfortable, regardless of the actual climate — a permanent zone of perfect weather in miniature.",
    "Those who hold it for extended periods develop an instinctive sense of magnetic north and an awareness of the nearest planar boundary.",
    "It leaves a faint afterimage that persists for a fraction of a second, as though reality needs a moment to catch up with its movements.",
    "Plants wither in its presence, but dead wood polishes itself to a high sheen — it favors the enduring over the living.",
    "In complete darkness, it emits just enough light to read by — the exact amount, no more, no less.",
    "The bearer develops an inexplicable craving for a specific food they have never eaten. Previous bearers report the same craving.",
    "Zones of wild magic become eerily calm in its presence, as if the item is exerting a stabilizing influence on the Weave.",
    "It hums a different melody for each person who touches it, as though singing a song unique to their soul.",
  ].freeze

  # ── Dramatic closings for legendary+ ──
  DRAMATIC_CLOSINGS = [
    "Many have sought to possess it; few have proven worthy. The rest were never seen again.",
    "Its true potential, scholars warn, has yet to be fully unleashed — and the consequences of doing so may reshape the world.",
    "Those who wield it speak of a burden as heavy as its power, for the artifact demands as much as it gives.",
    "It is said that the item chooses its bearer, not the other way around — and its criteria are known only to itself.",
    "Legends claim it will play a pivotal role when the world faces its darkest hour, a weapon against an enemy not yet born.",
    "Every generation produces a hero destined to carry it — and a villain destined to covet it. The cycle has never been broken.",
    "Its story is far from over. If anything, it has only just begun.",
    "Some believe destroying it would unmake a fundamental law of reality. Others believe that is precisely why it must be destroyed.",
    "The last three bearers died within a year of claiming it. Whether by coincidence, curse, or sacrifice, none can say.",
    "When the bearer sleeps, the artifact dreams for them — showing visions of what was, what is, and what might yet be.",
    "Elminster once held it in his hands for a full minute before setting it down and walking away without a word. He has refused to discuss the incident.",
    "The Harpers have classified it as a Tier-5 artifact — the same designation given to the Hand and Eye of Vecna.",
    "Candlekeep's monks have dedicated an entire sealed vault to documents pertaining to this item. Access requires the approval of the First Reader.",
    "Those who have wielded it and survived — a vanishingly small number — describe the experience as 'looking at the sun and seeing it look back.'",
    "In the end, the item will outlast its bearer, as it has outlasted every bearer before them. It is patient. It endures. It waits.",
    "Szass Tam has offered an open bounty of a million gold pieces and a guaranteed position in the Thayan hierarchy for its delivery. No one has collected.",
  ].freeze

  # ── Transitional phrases for weaving effects into narrative ──
  EFFECT_TRANSITIONS = [
    "Its most striking property is that it",
    "Those who have studied it note that it",
    "Beyond its physical form, it",
    "In battle, it",
    "When called upon, it",
    "More remarkably still, it",
    "Its enchantment ensures that it",
    "In the hands of a worthy bearer, it",
    "Perhaps most notably, it",
    "As if that were not enough, it also",
    "Seasoned adventurers who have used it confirm that it",
    "The sages of Candlekeep have documented that it",
    "Field reports from Harper agents confirm that it",
    "According to those who have witnessed it in action, it",
    "What truly sets it apart is that it",
  ].freeze

  # ── Historical anecdotes — Faerûn-enriched ──
  HISTORICAL_ANECDOTES = [
    "It once saved the life of %{wielder} during %{event}, turning a certain defeat into an improbable victory.",
    "Records in the library of Candlekeep mention it by a different name, suggesting it has reinvented itself across the centuries.",
    "%{wielder} carried it for seventeen years before passing it on, claiming it had 'finished what it came to do.'",
    "A thieves' guild in Waterdeep once placed a bounty of ten thousand gold on it — the contract was never fulfilled.",
    "It was thought lost during %{event}, but resurfaced decades later in the possession of a child who claimed to have found it 'waiting for them' in a forest.",
    "Three separate kingdoms list it among their crown treasures, though it has not rested in any vault for long.",
    "The sage Elminster is said to have examined it and spoken only two words: 'Be careful.'",
    "During %{event}, it is said to have acted of its own accord, protecting its bearer from a blow they never saw coming.",
    # Faerûn-specific anecdotes
    "%{wielder} used it to survive the Spellplague's wild magic storms, when other enchanted items were exploding or going inert.",
    "It was last seen in %{place} before %{event}, after which it disappeared from the historical record for three centuries.",
    "%{organization} maintained a dossier on it for decades, tracking its movements across the Sword Coast with obsessive detail.",
    "Volo once wrote a chapter about it, but Elminster insisted the chapter be removed. The debate between them reportedly lasted three days.",
    "The War Wizards of Cormyr attempted to confiscate it during %{event}, but %{wielder} had already vanished with it.",
    "It surfaced briefly in the markets of Calimport, where it changed hands seven times in a single day before disappearing again.",
    "During the siege of Mithral Hall, %{wielder} used it to hold a corridor against a hundred drow — a fact that even the Baenre house has reluctantly confirmed.",
    "A Red Wizard of Thay attempted to reverse-engineer its enchantments and was found the next morning, alive but permanently unable to cast spells above 3rd level.",
    "%{wielder} brought it to %{place}, where it resonated with the ambient magic so powerfully that the local ley lines shifted permanently.",
    "It was offered as tribute to the dragon Klauth — Old Snarl examined it, returned it, and told the terrified petitioners: 'Keep it. You will need it more than I.'",
  ].freeze

  def self.generate_description(rarity_name, effects, category, weapon_name = nil)
    cat_singular = category.name.downcase.singularize
    item_word = weapon_name.present? ? weapon_name.downcase : cat_singular
    effect_types = effects.map(&:effect_type).uniq
    power = effects.sum(&:power_level)

    case rarity_name
    when "Common"
      build_simple_description(item_word, effect_types)
    when "Uncommon"
      build_uncommon_description(rarity_name, item_word, effect_types)
    when "Rare"
      build_rare_description(rarity_name, item_word, effect_types, power)
    when "Very Rare"
      build_elaborate_description(rarity_name, item_word, effect_types, power)
    when "Legendary", "Ancestral"
      build_epic_description(rarity_name, item_word, effect_types, power)
    else
      "A mysterious #{item_word} of unknown origin."
    end
  end

  private

  # ── Fill template placeholders with random lore ──
  def self.fill_placeholders(text)
    text.gsub("%{smith}", LEGENDARY_SMITHS.sample)
        .gsub("%{wielder}", LEGENDARY_WIELDERS.sample)
        .gsub("%{event}", LEGENDARY_EVENTS.sample)
        .gsub("%{place}", LEGENDARY_PLACES.sample)
        .gsub("%{material}", EXOTIC_MATERIALS.sample)
        .gsub("%{organization}", ORGANIZATIONS.sample)
        .gsub("%{deity}", DEITIES.sample)
        .gsub("%{era}", AGES_AND_ERAS.sample)
  end

  # ── Get an effect description, filling material placeholders ──
  def self.effect_desc_for(effect_type)
    desc = EFFECT_DESCRIPTIONS[effect_type]&.sample
    desc ? fill_placeholders(desc) : nil
  end

  # ── Common: 1-2 sentences, functional and grounded ──
  def self.build_simple_description(item_word, effect_types)
    origin = fill_placeholders(ORIGINS["Common"].sample)
    desc = "A reliable #{item_word} of honest craftsmanship. #{origin}"
    if effect_types.any?
      effect_desc = effect_desc_for(effect_types.first)
      desc += " It #{effect_desc}." if effect_desc
    end
    desc
  end

  # ── Uncommon: 2-3 sentences, hint of story and character ──
  def self.build_uncommon_description(rarity_name, item_word, effect_types)
    origin = fill_placeholders(ORIGINS[rarity_name].sample)
    desc = "An unusual #{item_word} that stands apart from ordinary craftsmanship. #{origin}"
    if effect_types.any?
      transition = EFFECT_TRANSITIONS.sample
      effect_desc = effect_desc_for(effect_types.first)
      desc += " #{transition} #{effect_desc}." if effect_desc
    end
    desc += " #{PERSONALITY_TRAITS.sample}" if rand < 0.5
    desc
  end

  # ── Rare: 3-5 sentences with backstory and anecdotes ──
  def self.build_rare_description(rarity_name, item_word, effect_types, power)
    origin = fill_placeholders(ORIGINS[rarity_name].sample)
    desc = "A remarkable #{item_word} that radiates quiet power. #{origin}"

    transitions = EFFECT_TRANSITIONS.shuffle
    effect_types.first(2).each_with_index do |et, i|
      effect_desc = effect_desc_for(et)
      desc += " #{transitions[i] || EFFECT_TRANSITIONS.sample} #{effect_desc}." if effect_desc
    end

    if rand < 0.6
      anecdote = fill_placeholders(HISTORICAL_ANECDOTES.sample)
      desc += " #{anecdote}"
    end

    desc += " #{PERSONALITY_TRAITS.sample}"
    desc += " #{fill_placeholders(CURSES_AND_QUIRKS.sample)}" if rand < 0.3
    desc
  end

  # ── Very Rare: 4-6 sentences, rich narrative with named characters ──
  def self.build_elaborate_description(rarity_name, item_word, effect_types, power)
    origin = fill_placeholders(ORIGINS[rarity_name].sample)
    desc = origin.dup

    # Weave in effect descriptions with varied transitions
    transitions = EFFECT_TRANSITIONS.shuffle
    effect_types.first(3).each_with_index do |et, i|
      effect_desc = effect_desc_for(et)
      if effect_desc
        transition = transitions[i] || EFFECT_TRANSITIONS.sample
        desc += " #{transition} #{effect_desc}."
      end
    end

    # Historical depth
    anecdote = fill_placeholders(HISTORICAL_ANECDOTES.sample)
    desc += " #{anecdote}"

    # Personality + quirk
    traits = PERSONALITY_TRAITS.shuffle.first(rand(1..2))
    traits.each { |t| desc += " #{t}" }

    desc += " #{fill_placeholders(CURSES_AND_QUIRKS.sample)}" if rand < 0.5
    desc += " #{fill_placeholders(PROPHECIES.sample)}" if rand < 0.3
    desc
  end

  # ── Legendary & Ancestral: Full epic lore, 6+ sentences with deep history ──
  def self.build_epic_description(rarity_name, item_word, effect_types, power)
    origin = fill_placeholders(ORIGINS[rarity_name].sample)
    desc = origin.dup

    # Rich effect narrative with varied transitions
    transitions = EFFECT_TRANSITIONS.shuffle
    effect_types.each_with_index do |et, i|
      effect_desc = effect_desc_for(et)
      if effect_desc
        transition = transitions[i] || EFFECT_TRANSITIONS.sample
        desc += " #{transition} #{effect_desc}."
      end
    end

    # Multiple historical anecdotes for epic depth
    anecdotes = HISTORICAL_ANECDOTES.shuffle.first(2)
    anecdotes.each do |anecdote|
      desc += " #{fill_placeholders(anecdote)}"
    end

    # Multiple personality traits
    traits = PERSONALITY_TRAITS.shuffle.first(rand(2..3))
    traits.each { |t| desc += " #{t}" }

    # Curses, quirks, and prophecies
    desc += " Furthermore, #{fill_placeholders(CURSES_AND_QUIRKS.sample)}."
    desc += " #{fill_placeholders(PROPHECIES.sample)}" if rand < 0.6

    # Dramatic closing
    desc += " #{DRAMATIC_CLOSINGS.sample}"
    desc
  end

  # ══════════════════════════════════════════════════════
  # RECOMMENDATIONS — suggest effects based on current selection
  # ══════════════════════════════════════════════════════

  def self.recommend_effects(category, selected_effect_types, available_power)
    available = Effect.joins(:categories)
                      .where(categories: { id: category.id })
                      .where.not(effect_type: selected_effect_types)
                      .where("power_level <= ?", available_power)

    # Remove conflicting effects
    conflicting_types = selected_effect_types.flat_map { |t| CONFLICTS[t] || [] }.uniq
    available = available.where.not(effect_type: conflicting_types) if conflicting_types.any?

    # Score effects by synergy
    synergy_types = selected_effect_types.flat_map { |t| SYNERGIES[t] || [] }.uniq
    scored = available.map do |effect|
      score = synergy_types.include?(effect.effect_type) ? 10 : 0
      score += 5 if effect.power_level <= available_power # fits budget
      score += 3 if effect.power_level == available_power # exact fit = perfect
      { effect: effect, score: score, synergy: synergy_types.include?(effect.effect_type) }
    end

    scored.sort_by { |s| -s[:score] }
  end

  # ── Check if an effect conflicts with selected ones ──
  def self.conflicts?(effect_type, selected_types)
    selected_types.any? { |t| (CONFLICTS[t] || []).include?(effect_type) }
  end

  # ── Get synergies for a set of effect types ──
  def self.synergies_for(selected_types)
    selected_types.flat_map { |t| SYNERGIES[t] || [] }.uniq - selected_types
  end
end
