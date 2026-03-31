puts "Seeding Lore Data (Faerun + Middle-earth)..."

# Cleanup — only non-proper_name entries (proper names handled by 07_lore_entries.rb)
LoreEntry.where.not(category: "proper_name").delete_all

def lore_insert(lore_type, category, values, key: nil)
  records = values.map { |v| { lore_type: lore_type, category: category, key: key, value: v, created_at: Time.current, updated_at: Time.current } }
  LoreEntry.insert_all(records) if records.any?
end

def lore_insert_hash(lore_type, category, hash)
  records = hash.flat_map { |k, vals| vals.map { |v| { lore_type: lore_type, category: category, key: k.to_s, value: v, created_at: Time.current, updated_at: Time.current } } }
  LoreEntry.insert_all(records) if records.any?
end

# ══════════════════════════════════════════════════════════════════
# FAERÛN LORE CONSTANTS
# ══════════════════════════════════════════════════════════════════
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

SUFFIXES = [
  # Classic Forgotten Realms locations
  "of the Sword Coast", "of Undermountain", "of the Spine of the World",
  "of the High Forest", "of the Anauroch", "of the Moonsea",
  "of the Silver Marches", "of Myth Drannor", "of Netheril",
  "of the Underdark", "of Icewind Dale", "of Calimshan",
  "of the Dalelands", "of Cormanthor", "of Evermeet",
  # Deity-linked
  "of Mystra's Weave", "of Tempus's Fury", "of Kelemvor's Judgment",
  "of Tyr's Justice", "of Lathander's Dawn", "of Selune's Light",
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

LEGENDARY_SMITHS = [
  "Torvald the Ash-Handed", "Morwen Brightforge", "Kael'thas Ironvein",
  "Sister Elara of the Embers", "the blind dwarf Grundar", "Vaelith the Wandering Artisan",
  "the reclusive gnome Fizzwick", "Master Hendrick of Anvil's Rest",
  "the dragonborn smith Kriv Steelscale", "Orin Half-Giant",
  # Faerun-specific
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

LEGENDARY_WIELDERS = [
  "the paladin Serena Dawnshield", "warlord Thane Drakov",
  "the elven ranger Lirael Starbow", "archmage Verenthos the Unbound",
  "General Kira Stonefist", "the tiefling rogue Malachar",
  "High Priestess Ysolde", "the half-orc champion Grukk Ironjaw",
  "the drow exile Zaelen Nightwhisper", "Sir Aldric of the Silver Dawn",
  "Queen Thessara the Undying", "the monk Haru of the Broken Path",
  # Faerun-specific (canonical or inspired)
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

LEGENDARY_PLACES = [
  "the Forge of Falling Stars", "Mount Pyratheon's caldera",
  "the Sunken Temple of Vel'koz", "the Crystalline Caverns of Aethon",
  "the ruins of the Sky Citadel", "the Abyssal Rift of Xar'nath",
  "the Feywild crossing at Moonhollow", "the Dragonbone Wastes",
  "the Frozen Throne of Ithkar", "the Whispering Observatory",
  "the Tomb of the First Emperor", "the Living Dungeon of Morpheus",
  # Faerun-specific
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

LEGENDARY_EVENTS = [
  "the Siege of Ashenmoor", "the Night of Falling Stars",
  "the Sundering of the Veil", "the War of Broken Crowns",
  "the Dragon Conclave of the Third Age", "the Plague of Shadows",
  "the Great Convergence", "the Betrayal at Silver Gate",
  "the Battle of the Bleeding Fields", "the Eclipse of Empires",
  "the Pact of Eternal Flame", "the Cataclysm of the Weeping God",
  # Faerun-specific
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

DEITIES = [
  "Mystra, goddess of magic", "Tempus, god of war", "Tyr, god of justice",
  "Kelemvor, god of the dead", "Lathander, god of the dawn",
  "Selune, goddess of the moon", "Shar, goddess of darkness",
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

EXOTIC_MATERIALS = [
  "adamantine mined from the deepest veins of the Underdark",
  "mithral from the legendary deposits of Mithral Hall",
  "darksteel forged in the Shadowfell's perpetual twilight",
  "glassteel, as transparent as crystal and harder than diamond",
  "star metal harvested from a fallen fragment of the Tears of Selune",
  "dragonfang bone, taken from an ancient wyrm's jawbone",
  "a shard of raw Weave crystallized during the Spellplague",
  "residuum, the powdered remains of deconstructed magical artifacts",
  "moonstone infused with Selune's tears during a lunar eclipse",
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
  "it weighs nothing on moonless nights and twice as much during a full moon, as though Selune herself has a claim on it",
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
    "Assembled during a conjunction of Selune and her Tears by the priestesses of the Moonmaiden, each component blessed by a different aspect of the goddess.",
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
    # Deep Faerun lore
    "This item was present when Mystra was murdered during the Time of Troubles, and it absorbed a fragment of divine power as the goddess fell. The Weave itself shuddered, and a sliver of its fabric became permanently woven into this object. Elminster himself has examined it and refused to say what he found.",
    "Forged by Moradin in the foundry of Dwarfhome and gifted to the first king of Shanatar. It passed through every great dwarven kingdom — Oghrann, Gharraghaur, Iltkazar — before the fall of Shanatar scattered it to the winds. Dwarves who see it weep, though they cannot explain why.",
    "Created by a circle of seven Chosen of Mystra during the Era of Upheaval, each contributing a different aspect of the Weave. Midnight herself (Mystra reborn) is said to have blessed it, though the new goddess of magic is enigmatic about confirming such stories.",
    "This artifact surfaced in %{place} after %{event}. %{wielder} carried it for a time, but ultimately left it behind, writing in their journal: 'It has done what it came to do through me. I am merely the latest in a long line.' The journal is preserved in Candlekeep.",
    "Wrought from %{material} by %{smith} during %{era}. The creation process required the voluntary sacrifice of a celestial, whose essence was bound into the metal. On quiet nights, the item radiates a warmth that has nothing to do with temperature — it is the last echo of an angel's compassion.",
    "This is one of the Twelve Tears of Selune — artifacts said to have fallen to Toril when the goddess wept for the suffering of the mortal world. Only four have ever been found. The others are the subject of ceaseless quests by the Selunite faithful.",
  ],
  "Ancestral" => [
    "This artifact predates the gods themselves. Ancient texts speak of it as a fragment of the primordial force that shaped reality — a sliver of pure creation given form. It existed before language, before thought, before the first star ignited in the void. Those who hold it feel the weight of eternity pressing against their consciousness, the echo of a universe being born.",
    "Woven from the threads of fate by the Three Sisters who sit beyond time itself, this item was placed in the mortal world as a test — or perhaps a gift. Every prophecy ever spoken references it obliquely, and every great turning point in history can be traced back to its influence. It does not merely exist within destiny; it IS destiny made manifest.",
    "Born in the space between heartbeats of the Sleeping God, forged from the boundary between existence and oblivion. When the universe was young and formless, this item crystallized from the first act of will — the moment consciousness emerged from chaos. Scholars who study it too closely report that the boundaries of their own reality begin to blur.",
    "The oldest beings in existence — the primordial dragons, the elder elementals, the first fey — all remember a time when this item was already ancient. It carries within it the memory of a universe that existed before this one, a cosmos that collapsed so that ours might be born. To wield it is to touch infinity.",
    "Created at the exact moment the multiverse came into being, this artifact is simultaneously the first and last thing that will ever exist. Time flows differently in its presence. Heroes who have carried it describe experiencing their entire lifetime in a single breath, only to find that centuries have passed in the outside world.",
    "The concept of this artifact exists in every reality simultaneously. In each universe, a version manifests differently, but the core essence — the primordial spark of creation — remains identical. Sages theorize that if every version were brought together, reality itself would fold inward. None have dared attempt it.",
    # Deep cosmological Faerun lore
    "This item was forged in the Days of Thunder, before the humanoid races walked Toril. The creator races — the sarrukh, the batrachi, the aearee — shaped it from materials that no longer exist in the natural world. It passed through the hands of the Imaskari, the Netherese, the elves of Aryvandaar, and countless others. Each civilization added to its enchantment before falling to dust, and each civilization's greatest achievement lives on within it.",
    "When Ao the Overgod created the crystal sphere of Realmspace, a fragment of his will became embedded in the fabric of Toril. This is that fragment, given physical form by forces that predate even the primordials. Ao has never acknowledged its existence, which some theologians interpret as the most significant statement of all.",
    "This artifact was present at the casting of Karsus's Avatar — the only 12th-level spell ever cast — and survived the resulting catastrophe that killed Mystryl and destroyed Netheril. It absorbed a fragment of the original Weave as Mystryl died, and within it lives a sliver of magic as it existed before the current Mystra imposed her restrictions. Wizards who attune to it describe accessing 'a deeper layer' of the Weave — one that Mystra herself may not control.",
    "Forged by the primordials during the Dawn War against the gods, this weapon was created to unmake divine power itself. When the gods won, they could not destroy it — the act of unmaking the Unmaker would have paradoxically empowered it. Instead, they sealed it away in a prison of layered demiplanes, each one more impenetrable than the last. It escaped. It always escapes.",
    "The Nether Scrolls — the most powerful magical artifacts on Toril — reference this item not as a creation but as a constant, like gravity or the passage of time. The scrolls describe it as 'that which was before us, which will be after us, which exists in the spaces between our words.' Even the phaerimm, who corrupted the scrolls, left these passages untouched. They were afraid to alter them.",
    "Created during the Tearfall, when the world was young and the barriers between planes had not yet hardened. It is part artifact, part living spell, part divine thought — the categories blur when examining something this ancient. The last mortal to fully comprehend its nature was the Netherese arcanist Ioulaum, and the knowledge drove him to become an elder brain in a desperate attempt to expand his cognition enough to contain what he had learned.",
  ],
}.freeze

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

HISTORICAL_ANECDOTES = [
  "It once saved the life of %{wielder} during %{event}, turning a certain defeat into an improbable victory.",
  "Records in the library of Candlekeep mention it by a different name, suggesting it has reinvented itself across the centuries.",
  "%{wielder} carried it for seventeen years before passing it on, claiming it had 'finished what it came to do.'",
  "A thieves' guild in Waterdeep once placed a bounty of ten thousand gold on it — the contract was never fulfilled.",
  "It was thought lost during %{event}, but resurfaced decades later in the possession of a child who claimed to have found it 'waiting for them' in a forest.",
  "Three separate kingdoms list it among their crown treasures, though it has not rested in any vault for long.",
  "The sage Elminster is said to have examined it and spoken only two words: 'Be careful.'",
  "During %{event}, it is said to have acted of its own accord, protecting its bearer from a blow they never saw coming.",
  # Faerun-specific anecdotes
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

# ══════════════════════════════════════════════════════════════════
# FAERUN INSERTS
# ══════════════════════════════════════════════════════════════════
puts "  Seeding Faerun lore..."
lt = "faerun"
lore_insert_hash(lt, "prefix",               PREFIXES)
lore_insert_hash(lt, "category_title",       CATEGORY_TITLES)
lore_insert(lt,      "suffix",               SUFFIXES)
lore_insert(lt,      "simple_suffix",        SIMPLE_SUFFIXES)
lore_insert(lt,      "smith",                LEGENDARY_SMITHS)
lore_insert(lt,      "wielder",              LEGENDARY_WIELDERS)
lore_insert(lt,      "place",                LEGENDARY_PLACES)
lore_insert(lt,      "event",                LEGENDARY_EVENTS)
lore_insert(lt,      "deity",                DEITIES)
lore_insert(lt,      "organization",         ORGANIZATIONS)
lore_insert(lt,      "material",             EXOTIC_MATERIALS)
lore_insert(lt,      "age",                  AGES_AND_ERAS)
lore_insert(lt,      "curse",                CURSES_AND_QUIRKS)
lore_insert(lt,      "prophecy",             PROPHECIES)
lore_insert(lt,      "personality_trait",    PERSONALITY_TRAITS)
lore_insert(lt,      "dramatic_closing",     DRAMATIC_CLOSINGS)
lore_insert(lt,      "effect_transition",    EFFECT_TRANSITIONS)
lore_insert(lt,      "historical_anecdote",  HISTORICAL_ANECDOTES)
lore_insert_hash(lt, "origin",               ORIGINS)
lore_insert_hash(lt, "effect_description",   EFFECT_DESCRIPTIONS)
lore_insert_hash(lt, "effect_flavor",        EFFECT_FLAVOR)

# ══════════════════════════════════════════════════════════════════
# MIDDLE-EARTH LORE CONSTANTS
# ══════════════════════════════════════════════════════════════════
ME_PREFIXES = {
  "Common"    => %w[Worn Sturdy Rustic Humble Simple Honest Faithful Tempered Battered Reliable Solid Modest Seasoned Trusty Homely],
  "Uncommon"  => %w[Elven Dwarven Númenórean Dúnadan Keen Blessed Gleaming Valiant Embered Ironforged Starlit Westron Gondorian Rohirric Silvered],
  "Rare"      => %w[Runed Enchanted Mystic Hallowed Moon-wrought Star-kindled Fëanorian Noldorin Sindarin Silvan Mithril-woven Dwimmer-crafted Spell-forged Gondolindrim Eregion-wrought],
  "Very Rare" => %w[Ainur-touched Void-wrought Eldar-forged Shadow-bane Silmaril-lit Valar-blessed Oromë-swift Aulë-tempered Ulmo-quenched Morgul-bane Undying Maiar-kindled Fëanor-inspired Celebrimbor-wrought Telchar-forged],
  "Legendary" => %w[Doom-spoken World-shaping Oath-bound Silmaril-blessed Noldor-crowned Valar-forged Doom-of-Mandos Morgoth-bane Ring-rival Flame-imperishable First-born Gondolin-wrought Undying-Lands Eärendil-blessed Fate-woven],
  "Ancestral" => %w[Primordial Ainulindalë-born Ilúvatar-willed Flame-imperishable Timeless Void-born Creation-sung World-founding Ea-shaping Music-born Thought-of-Ilúvatar Un-made First-conceived Eternal Boundless],
}.freeze

# ── Category-based name titles ──
ME_CATEGORY_TITLES = {
  "Weapons"    => %w[Blade Edge Fang Wrath Fury Bane Sting Cleaver Glamdring Grond Aeglos Gurthang Anglachel Orcrist],
  "Armor"      => %w[Bulwark Hauberk Corslet Ward Coat Panoply Mail Harness Byrnie Plate Aegis Mantle Shell],
  "Shields"    => %w[Wall Guardian Barrier Ward Buckler Defender Protector Aegis Bulwark Rampart Shield Targe Escutcheon],
  "Potions"    => %w[Draught Elixir Cordial Miruvor Athelas Ent-draught Lembas-water Tincture Essence Distillation Infusion Flask Brew],
  "Scrolls"    => %w[Codex Tome Script Decree Rune Glyph Tengwar Cirth Writ Grimoire Folio Testament Chronicle],
  "Rings"      => %w[Band Circle Ring Seal Vilya Narya Nenya Annulus Coil Signet Loop Crown Cipher],
  "Amulets"    => %w[Talisman Pendant Jewel Silmaril Evenstar Elfstone Nauglamír Elessar Locket Token Wardstone Phylactery],
  "Wands"      => %w[Rod Scepter Staff Wand Conduit Channeler Beacon Implement Spark Focus Catalyst Baton],
  "Staffs"     => %w[Staff Pillar Spire Rod Crook Scepter Stave Mace Monolith Column Obelisk Crozier],
  "Boots"      => %w[Treads Striders Walkers Greaves Steps Runners Sabatons Trackers Pathfinders Wanderers Sojourners Wayfarers],
  "Gloves"     => %w[Grasp Clutch Grip Gauntlets Mitts Fists Vambraces Bracers Hands Touch Talons Fingers],
  "Helms"      => %w[Crown Helm Casque Crest Diadem Dragon-helm Visor Circlet Coronet Tiara Sallet Pinnacle],
  "Cloaks"     => %w[Shroud Mantle Veil Cape Cloak Shadow Wrap Lórien-cloth Raiment Vestment Cowl Pall],
  "Books"      => %w[Grimoire Lexicon Codex Chronicle Thain's-Book Red-Book Palimpsest Almanac Volume Libram Compendium Folio],
  "Gems"       => %w[Silmaril Shard Crystal Jewel Stone Heart Arkenstone Elessar Phial Prism Geode Mote],
  "Ammunition" => %w[Bolt Arrow Dart Quarrel Shot Shaft Spike Needle Missile Slug Round],
  "Bracelet"   => %w[Bangle Cuff Chain Torc Armlet Circlet Shackle Link Fetter Coil Band],
  "Trinkets"   => %w[Curio Relic Token Keepsake Heirloom Bauble Memento Oddity Fetish Charm Icon],
}.freeze

# ── Suffixes: Middle-earth locations, figures, events ──
ME_SUFFIXES = [
  # Elven realms & cities
  "of Gondolin", "of Nargothrond", "of Doriath", "of Menegroth",
  "of Rivendell", "of Lothlórien", "of the Grey Havens", "of Eregion",
  "of Lindon", "of Tirion upon Túna", "of Alqualondë", "of Formenos",
  "of the Falas", "of Ossiriand", "of Tol Eressëa", "of Caras Galadhon",
  # Dwarven strongholds
  "of Khazad-dûm", "of Erebor", "of Nogrod", "of Belegost",
  "of the Iron Hills", "of Aglarond", "of the Glittering Caves",
  "of Tumunzahar", "of Gabilgathol", "of Hadhodrond",
  # Númenor & Gondor
  "of Númenor", "of Armenelos", "of Minas Tirith", "of Osgiliath",
  "of Minas Ithil", "of Annúminas", "of Fornost", "of Dol Amroth",
  "of Pelargir", "of Gondor", "of Arnor",
  # Rohan & the North
  "of Edoras", "of Helm's Deep", "of the Riddermark",
  "of Bree", "of the Shire", "of Isengard",
  # Dark places
  "of Angband", "of Thangorodrim", "of Barad-dûr", "of Mordor",
  "of Dol Guldur", "of Minas Morgul", "of Utumno",
  # Valinor
  "of Valinor", "of Aman", "of Taniquetil", "of the Undying Lands",
  "of the Blessed Realm", "of Mandos", "of Aulë's Forge",
  # Valar & Maiar
  "of Manwë's Breath", "of Ulmo's Depths", "of Aulë's Fire",
  "of Yavanna's Song", "of Varda's Stars", "of Oromë's Hunt",
  "of Nienna's Tears", "of Mandos's Doom", "of Tulkas's Wrath",
  "of Lúthien's Grace", "of Eärendil's Light",
  # Events & ages
  "of the First Age", "of the Elder Days", "of the Years of the Trees",
  "of the War of Wrath", "of the Last Alliance", "of the Nirnaeth Arnoediad",
  "of the Fall of Gondolin", "of the Dagor Bragollach",
  "of the Darkening of Valinor", "of the War of the Ring",
  "of the Kinslaying", "of the Flight of the Noldor",
  # Abstract / epic
  "of the Firstborn", "of the Secondborn", "of the Free Peoples",
  "of Shadow and Flame", "of Starlight", "of the Deathless Lands",
  "of the Sundering Seas", "of the Straight Road",
  "of the Long Defeat", "of the Uttermost West",
].freeze

ME_SIMPLE_SUFFIXES = [
  "of Power", "of Might", "of Valor", "of Grace", "of Wrath",
  "of Wisdom", "of Starlight", "of Shadow", "of Flame", "of Doom",
  "of the West", "of the North", "of the Eldar", "of the Dwarves",
  "of the Dúnedain", "of Twilight", "of Dawn", "of Mithril", "of Stars",
  "of the Mark",
].freeze

# ══════════════════════════════════════════════════════
# DESCRIPTION LORE — Deep Middle-earth
# ══════════════════════════════════════════════════════

ME_LEGENDARY_SMITHS = [
  # Valar & Maiar
  "Aulë the Smith, Maker of the Dwarves and greatest craftsman among the Valar",
  "Sauron, when he was yet Mairon the Admirable, before his corruption by Morgoth",
  "Curumo (Saruman), whose skill with ring-lore and metal was surpassed only by his ambition",
  # Noldorin Elves
  "Fëanor, greatest of the Noldor, whose hands wrought the Silmarils themselves",
  "Celebrimbor, grandson of Fëanor and lord of the Gwaith-i-Mírdain of Eregion",
  "Curufin the Crafty, fifth son of Fëanor, who inherited much of his father's skill",
  "Mahtan, the great Noldorin smith who taught Fëanor the secrets of metalwork",
  "the smiths of the Gwaith-i-Mírdain, the Jewel-smiths of Eregion",
  "Eöl the Dark Elf of Nan Elmoth, who forged Anglachel and Anguirel from a fallen star",
  "Pengolodh the Wise of Gondolin, loremaster and craftsman of the Hidden City",
  # Dwarves
  "Telchar of Nogrod, greatest of Dwarf-smiths, who forged Narsil and Angrist",
  "Gamil Zirak, master smith of Nogrod and teacher of Telchar",
  "Narvi, the Dwarf-craftsman who wrought the Doors of Durin with Celebrimbor",
  "the smiths of Erebor, heirs to the craft traditions of Durin's Folk",
  "the Longbeard forgemasters of Khazad-dûm in its years of glory",
  "the weaponsmiths of Nogrod, famed throughout Beleriand for their steel",
  "the armorsmiths of Belegost who fashioned the Dragon-helm of Dor-lómin",
  "Thorin Oakenshield's own armorers, working in the reclaimed halls of Erebor",
  # Men
  "the Númenórean weapon-wrights of Armenelos, whose art rivaled the Eldar",
  "the master smiths of Westernesse in the days of Tar-Minastir",
  "the Dúnedain craftsmen of Annúminas, before the fall of the North-kingdom",
  "the armorsmiths of Gondor in the days of its greatest strength",
  "a nameless smith of the Edain in the service of King Thingol of Doriath",
  # Gondolin specialists
  "the artificers of Gondolin, working in secret forges beneath Amon Gwareth",
  "Rog, lord of the House of the Hammer of Wrath in Gondolin",
  "the craftsmen of the House of the Golden Flower in the Hidden City",
].freeze

ME_LEGENDARY_WIELDERS = [
  # First Age heroes
  "Fingolfin, High King of the Noldor, who dueled Morgoth before the gates of Angband",
  "Fëanor, Spirit of Fire, mightiest of the Children of Ilúvatar",
  "Fingon the Valiant, who rescued Maedhros from Thangorodrim",
  "Turgon, King of Gondolin, the Hidden City",
  "Beren Erchamion, who cut a Silmaril from Morgoth's iron crown",
  "Lúthien Tinúviel, fairest of all the Children of Ilúvatar",
  "Túrin Turambar, the tragic hero who slew Glaurung the dragon",
  "Húrin Thalion, the Steadfast, who stood alone against Morgoth's armies",
  "Ecthelion of the Fountain, who slew Gothmog Lord of Balrogs",
  "Glorfindel of the House of the Golden Flower, who slew a Balrog in the Fall of Gondolin",
  "Eärendil the Mariner, bearer of the Silmaril and hope of Elves and Men",
  "Thingol Greycloak, King of Doriath and lord of the Sindar",
  "Maedhros the Tall, eldest son of Fëanor",
  "Maglor the Singer, whose voice was the fairest in all the world",
  "Beleg Cúthalion, greatest archer among the Elves of Doriath",
  # Second Age
  "Gil-galad, last High King of the Noldor in Middle-earth, who bore the spear Aeglos",
  "Elendil the Tall, who founded the realms of Arnor and Gondor",
  "Isildur, who cut the One Ring from Sauron's hand",
  "Anárion, defender of Minas Anor against Sauron's forces",
  "Elrond Half-elven, Herald of Gil-galad and lord of Rivendell",
  "Círdan the Shipwright, oldest of the Elves in Middle-earth",
  # Third Age
  "Gandalf the Grey, who became Gandalf the White, wielder of Glamdring and bearer of Narya",
  "Aragorn, son of Arathorn, heir of Isildur, who bore Andúril Flame of the West",
  "Théoden King of Rohan, who rode to glory at the Pelennor Fields",
  "Éowyn, shieldmaiden of Rohan, who slew the Witch-king of Angmar",
  "Éomer, Third Marshal of the Riddermark and later King of Rohan",
  "Boromir, Captain of the White Tower, who fell defending the Halflings",
  "Faramir, Captain of the Rangers of Ithilien",
  "Legolas Greenleaf of the Woodland Realm",
  "Gimli, son of Glóin, Elf-friend and Lord of Aglarond",
  "Thorin Oakenshield, King under the Mountain",
  "Bilbo Baggins, who bore Sting into the darkness of Mirkwood",
  "Frodo Baggins, Ring-bearer, who carried the One Ring to Mount Doom",
  "Samwise Gamgee, the truest of all companions, who bore the Phial of Galadriel",
  "Prince Imrahil of Dol Amroth, whose line bore Elven blood",
  "the Witch-king of Angmar, Lord of the Nazgûl",
].freeze

ME_LEGENDARY_PLACES = [
  # Valinor
  "the forge-halls of Aulë beneath Taniquetil in Valinor",
  "Fëanor's workshop in Tirion upon Túna, where the Silmarils were wrought",
  "the halls of Mahtan in Valinor, where the art of metalwork was perfected",
  "the Gardens of Lórien in Valinor, where dreams take form",
  # First Age Beleriand
  "the hidden forges of Gondolin beneath Amon Gwareth, the Hill of Watch",
  "Menegroth, the Thousand Caves of King Thingol in Doriath",
  "the great smithies of Nogrod in the Blue Mountains",
  "the halls of Belegost, where the finest Dwarf-mail was wrought",
  "Nargothrond, the great underground fortress of Finrod Felagund",
  "the smithies of the Falas, where Círdan's people wrought ships and steel",
  "the hidden vale of Tumladen, where Gondolin the Beautiful stood",
  "Himring, the fortress of Maedhros, cold hill upon the March of Maedhros",
  "the forge of Eöl in the dark woods of Nan Elmoth",
  # Second Age
  "the Gwaith-i-Mírdain's workshops in Ost-in-Edhil, chief city of Eregion",
  "the Sammath Naur, the Chambers of Fire within Orodruin where the One Ring was forged",
  "the armories of Númenor in Armenelos the Golden",
  "Khazad-dûm in the days of Durin, when mithril flowed like water",
  "the Tower of Avallónë on Tol Eressëa, where the Palantíri were made",
  # Third Age
  "the forges of Erebor, the Lonely Mountain, reclaimed by Thorin's company",
  "Rivendell, the Last Homely House, where Andúril was reforged from the shards of Narsil",
  "the workshops of Isengard before Saruman's fall to darkness",
  "the deep halls of Aglarond, the Glittering Caves of Helm's Deep",
  "the armories of Minas Tirith in the days of its greatest strength",
  "the smithies of Dale, rebuilt after the fall of Smaug",
  "the Prancing Pony in Bree, where many a tale is told and many a relic changes hands",
  "a hidden forge in the depths of the Misty Mountains, long forgotten",
  "the ruins of Annúminas beside Lake Evendim",
  "the ancient dwarf-holds beneath the Grey Mountains",
  "Dol Amroth, the castle by the sea, where Gondorian and Elven craft mingled",
].freeze

ME_LEGENDARY_EVENTS = [
  # Years of the Trees & First Age
  "the Darkening of Valinor, when Morgoth and Ungoliant destroyed the Two Trees",
  "the Flight of the Noldor from Valinor and the dreadful Kinslaying at Alqualondë",
  "the Dagor-nuin-Giliath, the Battle under Stars, first battle of the Noldor in Middle-earth",
  "the Dagor Aglareb, the Glorious Battle that established the Siege of Angband",
  "the Dagor Bragollach, the Battle of Sudden Flame that broke the Siege of Angband",
  "the Nirnaeth Arnoediad, the Battle of Unnumbered Tears, greatest disaster of the Eldar",
  "the Fall of Gondolin, when Morgoth's hosts destroyed the fairest city of the Elves",
  "the Fall of Nargothrond, brought low by the cunning of Glaurung the dragon",
  "the Fall of Doriath, when Dwarves and Elves shed blood over the Nauglamír and a Silmaril",
  "the Quest of Beren and Lúthien for the Silmaril from Morgoth's crown",
  "Fingolfin's single combat with Morgoth at the gates of Angband",
  "the slaying of Glaurung by Túrin Turambar at the ravine of Cabed-en-Aras",
  "the War of Wrath, when the Valar overthrew Morgoth and Beleriand was broken",
  "the Oath of Fëanor and his sons, which drove the doom of the Noldor",
  "Eärendil's voyage to Valinor, bearing the Silmaril, to plead for aid against Morgoth",
  # Second Age
  "the forging of the Rings of Power in Eregion by Celebrimbor and the disguised Sauron",
  "the forging of the One Ring by Sauron in the fires of Mount Doom",
  "the War of the Elves and Sauron, which laid waste to Eregion",
  "the Downfall of Númenor, when the Blessed Realm was removed from the circles of the world",
  "the founding of Gondor and Arnor by Elendil and his sons",
  "the War of the Last Alliance of Elves and Men against Sauron",
  "the Battle of Dagorlad and the seven-year siege of Barad-dûr",
  "the death of Gil-galad and Elendil on the slopes of Orodruin",
  # Third Age
  "the Battle of the Five Armies before the gates of Erebor",
  "the fall of Khazad-dûm when the Dwarves awoke Durin's Bane",
  "the War of the Ring, when the free peoples made their last stand against Sauron",
  "the Battle of the Pelennor Fields, greatest battle of the Third Age",
  "the Battle of the Hornburg at Helm's Deep",
  "the destruction of the One Ring in the fires of Mount Doom",
  "the fall of Gandalf the Grey in Khazad-dûm and his return as the White",
  "the siege of Minas Tirith by the armies of Mordor",
  "Éowyn's slaying of the Witch-king upon the Pelennor Fields",
  "the charge of the Rohirrim at dawn upon the Pelennor",
].freeze

# ── Valar, Maiar, and Powers (equivalent to DEITIES) ──
ME_DEITIES = [
  "Ilúvatar, the One, Creator of all",
  "Manwë Súlimo, King of the Valar, Lord of the Breath of Arda",
  "Varda Elentári, Queen of the Stars, whom the Elves call Elbereth Gilthoniel",
  "Ulmo, Lord of Waters, who dwells alone in the deeps of the Outer Sea",
  "Aulë the Smith, maker of mountains and metals, who created the Dwarves",
  "Yavanna Kementári, Queen of the Earth, giver of fruits and growing things",
  "Mandos (Námo), the Doomsman of the Valar, keeper of the Houses of the Dead",
  "Vairë the Weaver, who weaves the story of the world in her tapestries",
  "Nienna, who mourns for the marring of Arda, from whose tears wisdom is born",
  "Oromë the Great, the Huntsman of the Valar, who first found the Elves",
  "Tulkas Astaldo, the Champion of Valinor, strongest of all in deeds of prowess",
  "Nessa the Dancer, swift as an arrow, whose joy is in running and dance",
  "Estë the Gentle, healer of hurts and of weariness",
  "Lórien (Irmo), master of visions and dreams, who tends the Gardens of Lórien in Valinor",
  "Morgoth Bauglir, the Dark Enemy, once Melkor mightiest of the Ainur",
  "Sauron the Deceiver, the Dark Lord, once a Maia of Aulë",
  "Gandalf (Olórin), wisest of the Maiar, who walked among the Elves unseen",
  "Saruman (Curumo), once head of the Istari, whose knowledge of ring-craft was great",
  "Radagast the Brown, friend of birds and beasts",
  "the Balrogs, Maiar corrupted by Morgoth into spirits of fire and shadow",
  "Tom Bombadil, Eldest, whose true nature none can say",
  "Goldberry, the River-daughter",
  "Ungoliant, the primordial darkness in spider form, whose hunger was never sated",
].freeze

# ── Organizations & peoples ──
ME_ORGANIZATIONS = [
  "the Noldor, the Deep Elves, mightiest of the Eldar in lore and craft",
  "the Sindar, the Grey Elves of Beleriand under King Thingol",
  "the Silvan Elves of Lothlórien under Galadriel and Celeborn",
  "the Wood-elves of the Woodland Realm under King Thranduil",
  "Durin's Folk, the Longbeards, eldest and greatest of the Dwarf-kindreds",
  "the Firebeards and Broadbeams of Nogrod and Belegost",
  "the Dúnedain of the North, Rangers and heirs of Arnor",
  "the Dúnedain of the South, lords of Gondor",
  "the Rohirrim, the Horse-lords of the Riddermark",
  "the Istari, the five Wizards sent by the Valar to contest Sauron",
  "the White Council, led by Saruman and later Gandalf, who opposed the Shadow",
  "the House of Fëanor, bound by their terrible Oath",
  "the House of Fingolfin, who endured the crossing of the Helcaraxë",
  "the Gwaith-i-Mírdain, the Jewel-smiths of Eregion",
  "the Ents of Fangorn, shepherds of the trees since the Elder Days",
  "the Eagles of Manwë, led by Thorondor and later Gwaihir",
  "the Beornings, skin-changers of the Vales of Anduin",
  "the faithful Númenóreans, the Elendili, who defied Sauron and Ar-Pharazôn",
  "the Grey Company, Dúnedain who rode with Aragorn to the Paths of the Dead",
  "the Fellowship of the Ring, the Nine Walkers sent from Rivendell",
  "the Galadhrim, the tree-people of Lothlórien",
  "the Nazgûl, the Nine Ring-wraiths, enslaved kings of Men",
  "the Guard of the Citadel of Minas Tirith",
  "the Corsairs of Umbar, descendants of the King's Men of Númenor",
].freeze

# ── Exotic materials ──
ME_EXOTIC_MATERIALS = [
  "mithril, the true-silver of Khazad-dûm, most precious of metals, light as silk and hard as dragon-scales",
  "galvorn, the dark metal devised by Eöl in Nan Elmoth, black and shining as jet",
  "ithildin, the star-moon substance that glows only by starlight or moonlight, wrought by the Noldor",
  "the black iron of Angband, forged in Morgoth's pits beneath Thangorodrim",
  "silima, the crystalline substance invented by Fëanor, harder than diamond, from which the Silmarils were made",
  "a fallen star of Aulë's making, sky-iron found still warm upon the earth",
  "mallorn-wood from the trees of Lothlórien, golden and imperishable",
  "lebethron, the beloved wood of the woodwrights of Gondor",
  "laen, the volcanic glass wrought by Dwarf-smiths into blades as hard as steel",
  "tilkal, the ancient alloy of six metals spoken of in the oldest tales",
  "the white stone of Minas Tirith, quarried from the Mountains of Shadow before Sauron's return",
  "steel tempered in dragon-fire, quenched in the icy waters of Celebrant",
  "a splinter of Grond, the great mace of Morgoth, the Hammer of the Underworld",
  "a fragment of the Silmaril-light caught in crystal during the Darkening of Valinor",
  "iron from the ruin of Thangorodrim, twisted by the power of a fallen Vala",
  "elanor-gold, metal refined from the golden flowers of Lothlórien by Galadhrim craftsmen",
  "Westernesse steel, forged in Númenor with arts now lost to mortal Men",
  "dwarf-steel from the deep forges of Erebor, folded a hundred times in Durin's tradition",
  "silver from the mines of Celebdil, blessed by the presence of the Mirrormere",
  "athelas-infused bronze, wrought by the healers of Gondor for items of restoration",
  "bark of the White Tree of Gondor, preserved since the days of Nimloth",
  "a shard of the Elessar, the Elfstone of Eärendil, green as the living earth",
  "obsidian from the slopes of Orodruin, still warm with the fires of Mount Doom",
  "ice from the Helcaraxë, the Grinding Ice, that never melts even in the hottest forge",
].freeze

ME_AGES_AND_ERAS = [
  "the Time before Time, when only Ilúvatar and the Ainur existed in the Void",
  "the Ainulindalë, the Great Music by which Arda was conceived",
  "the Years of the Lamps, when Arda was lit by Illuin and Ormal",
  "the Years of the Trees, when the light of Telperion and Laurelin illuminated Valinor",
  "the First Age of the Sun, the Elder Days of Beleriand's wars against Morgoth",
  "the years of the Siege of Angband, when the Noldor held Morgoth at bay (F.A. 60–455)",
  "the years after the Dagor Bragollach (F.A. 455), when the Siege was broken",
  "the Second Age, when the Rings of Power were forged and Númenor rose and fell",
  "the height of Númenor's power (S.A. 600–3255), when its ships ruled every sea",
  "the years of Eregion's glory (S.A. 750–1697), when Elves and Dwarves worked in friendship",
  "the forging of the Rings of Power (S.A. 1500–1590) by the Gwaith-i-Mírdain",
  "the Third Age, from the defeat of Sauron at the Last Alliance to the destruction of the One Ring",
  "the years of Gondor's greatest might (T.A. 1–1050), when the South-kingdom flourished",
  "the Long Winter (T.A. 2758–2759) and the years of hardship that followed",
  "the years of the Watchful Peace (T.A. 2063–2460), when Sauron withdrew from Dol Guldur",
  "the Quest of Erebor (T.A. 2941), when Thorin's company reclaimed the Lonely Mountain",
  "the War of the Ring (T.A. 3018–3019), the final struggle against Sauron",
].freeze

ME_CURSES_AND_QUIRKS = [
  "it is said that the shadow of Morgoth's malice falls upon all who covet it, though those who receive it freely find it a faithful servant",
  "once each age it vanishes from the hands of its keeper, as though summoned by Mandos himself, only to appear again where it is most needed",
  "prolonged possession kindles in the bearer's eyes a faint Elven-light, the afterglow of the Trees that once lit the world",
  "this item is said to have a twin, wrought in the same forge in the same hour, and the two sing a chord when brought near each other",
  "it will not suffer the hand of an Orc or servant of the Shadow — it becomes burning cold to the touch of the wicked",
  "on occasion it whispers in Quenya, the High Speech of the Noldor, words that none now living fully comprehend",
  "those who die bearing it are said to find swifter passage through the Halls of Mandos, as though the item vouches for them",
  "it is warm to the touch of Elf-friends and cold as the Helcaraxë to all others",
  "the palantíri cannot perceive it — its existence is veiled from the Seeing Stones as though it were never made",
  "on nights when Eärendil's star burns brightest it weighs nothing, and on moonless nights twice as much, as though the Silmaril in the sky has a claim upon it",
  "anyone who bears it for more than a day begins to understand Sindarin, even if they have never heard the Elven-tongue spoken",
  "it carries the faint scent of athelas — kingsfoil — and wherever it rests, the air smells of spring after rain",
  "Elven-sight reveals traces of the old script of Fëanor upon it, runes that tell a story different to each reader",
  "if broken, it mends itself slowly, drawing on the ambient light of sun and stars — the process takes seven days and seven nights",
  "it is invisible to the servants of Sauron, passing through their awareness like a whisper in a storm",
  "songbirds gather near it, and in Lothlórien the nightingales sing more sweetly in its presence",
  "it hums with a deep, resonant note when brought near other objects of power, as though greeting kindred spirits",
].freeze

ME_PROPHECIES = [
  "The ancient prophecy of Mandos speaks of such an item: 'When the world is broken and remade, this shall endure; for it was made with love, and love alone outlasts the Long Defeat.'",
  "In the Red Book of Westmarch, a passage in Bilbo's own hand describes a relic matching its description: 'It seemed to me a thing of great age and greater purpose, and I dared not keep it long.'",
  "The Dúnedain Rangers preserve an oral tradition about 'the burden that lightens': an artifact that grows easier to bear the more just its wielder's cause.",
  "Galadriel's Mirror once showed a vision of this item in the hands of a figure standing alone before a great darkness — whether past or future, the Lady would not say.",
  "Elrond spoke of it at the Council, though his words were not recorded in the common account: 'I have seen its like before, in an age when such things were more common — and more dangerous.'",
  "The Palantír of Orthanc, when wrested from Saruman's influence, showed a brief vision of this item resting upon a stone table in a place of great light. Gandalf refused to interpret the vision.",
  "A verse in the Lay of Leithian, in Bilbo's translation, may refer to it: 'Forged in fire, quenched in tears / it shall outlast the fleeting years / and when the Shadow falls once more / be beacon bright on darkened shore.'",
  "The Ents of Fangorn speak of a 'hard-thing-that-remembers' in their slow language — Treebeard acknowledged it might be this item, but said he would need a very long time to be certain.",
].freeze

# ── Origins per rarity ──
ME_ORIGINS = {
  "Common" => [
    "Forged by a village smith in the lands of Bree, from honest iron and simple craft.",
    "Made by a Hobbit tinker in the workshops of Michel Delving, sturdy and practical.",
    "Crafted by a journeyman smith in the lower circles of Minas Tirith.",
    "Produced in the workshops of Dale, following the craft traditions restored after Smaug's fall.",
    "Fashioned during a long winter in a Dúnedain camp, from what materials were at hand.",
    "Purchased from a peddler on the East-West Road, its origins unknown but its quality sound.",
    "Wrought by an apprentice of the Erebor forges — functional, reliable, a credit to Dwarf teaching.",
    "Made by the Men of Rohan, sturdy as the horses they ride and twice as dependable.",
    "Assembled from salvaged materials after a skirmish with Orcs along the Misty Mountains.",
    "Crafted by a Gondorian smith of the third circle, skilled but not yet a master.",
    "Fashioned in Lake-town, where the craft of Men is practical and trade-worthy.",
    "Forged in the smithies of Belegost's diminished remnant in the Blue Mountains, plain but well-made.",
  ],
  "Uncommon" => [
    "Forged under a Hunter's Moon by an Elven smith of the Grey Havens, the work of a single night's inspiration.",
    "Discovered in a troll-hoard in the Trollshaws, alongside other spoils of forgotten travelers.",
    "Created by a Dúnedain Ranger who wove fragments of old Westernesse craft into its making.",
    "Blessed by an Elf-lord in exchange for aid during the crossing of the Misty Mountains.",
    "Recovered from the hoard of a young dragon in the Withered Heath.",
    "Won in the Battle of Five Armies and carried south by a victorious warrior of Dale.",
    "Found in the ruins of Annúminas by a Ranger who recognized its quality.",
    "Commissioned by the steward of Dol Amroth as a gift for a loyal knight.",
    "Imbued with minor enchantments by a Wizard of lesser order, one of the Blue Istari's students.",
    "Traded by a Dwarf-merchant of the Iron Hills who swore it was forged in old Erebor — for once, the merchant told the truth.",
    "Crafted in Rivendell as an exercise in Noldorin technique; the student's work surpassed expectations.",
    "Found among the possessions of a fallen warrior of Gondor in the ruins of Osgiliath.",
    "Enchanted by an Elven-smith of Mirkwood with subtle woodcraft spells woven into the metal.",
    "Recovered from a Corsair ship captured off the coast of Belfalas.",
    "Discovered among the grave-goods of a barrow in the Barrow-downs, purified by Tom Bombadil himself.",
  ],
  "Rare" => [
    "Forged in rivalry between two Dwarf-clans of Erebor, each striving to outdo the other's craft.",
    "Drawn from the dreams of an Elven-lord who slept beneath the eaves of Lothlórien for a year and a day.",
    "Crafted by Dwarven runesmiths in the deep chambers of Khazad-dûm, quenched in the cold waters of the Mirrormere.",
    "Recovered from the tomb of a Dúnedain chieftain whose sword-arm defended Arnor for forty years.",
    "Imbued with power during a rare conjunction of Eärendil's star and the moon.",
    "Salvaged from the wreckage of a Númenórean ship found beneath the waters of the Bay of Belfalas.",
    "Forged by %{smith} during a three-day labor guided by visions of the Blessed Realm.",
    "Discovered in a vein of mithril in the Mines of Moria, shaped as if by nature itself over uncounted years.",
    "Enchanted in the workshops of Eregion in the brief years of peace before Sauron's war.",
    "Created from %{material}, worked by %{smith} under the light of Ithil on Midsummer's Eve.",
    "Recovered from the ruins of a Númenórean outpost in the south, its enchantments preserved across millennia.",
    "Forged during %{era} and passed through many hands before vanishing from all records — until now.",
    "Found in a sealed chamber beneath Erebor, alongside a journal in Cirth runes describing its creation.",
    "Crafted at the request of a mortal who won a riddle-contest with a Dragon.",
    "Woven with Elven enchantment by a circle of Galadhrim, shaped over a full year under the mallorn trees.",
    "Pulled from the clutches of a stone-troll in the Ettenmoors, still gripping it after centuries of petrifaction.",
  ],
  "Very Rare" => [
    "Forged from star-iron that fell upon Arda in the First Age, still carrying the cold fire of the firmament. The metal remembers the void between the stars.",
    "Drawn from a barrow of the First Age by an Elf who walked the paths of the dead and returned unchanged. The item still carries the chill of that passage.",
    "Created during the War of Wrath, when the Valar broke Thangorodrim and the earth itself was remade. Its maker sacrificed their craft-hand to complete the work.",
    "Assembled from fragments of three ancient relics, each broken in a different age. The echoes of their former power hum within this new form.",
    "Born from the last ember of one of the Two Trees of Valinor, caught in crystal before the light faded forever from the world.",
    "Shaped by %{smith} in %{place}, where the boundary between Middle-earth and the Undying Lands grows thin as gossamer. Echoes of the Blessed Realm cling to it still.",
    "This relic was the prize of %{event}. %{wielder} claimed it from the ruin, though some say it chose its bearer rather than the other way around.",
    "Grown — not forged — in the gardens of Lothlórien, where Galadriel's power causes metal to bloom like elanor and gems to ripen on crystal vines. The process took seven mortal lifetimes.",
    "Forged in the deeps of Erebor using techniques passed down from Durin the Deathless himself. The fire of that ancient tradition burns within it.",
    "Created from %{material}, shaped during %{event} by %{smith}. It carries the memory of that day like a scar — or a rune of power.",
    "Recovered from the ruin of Dol Guldur after the White Council drove out the Necromancer. What dark arts had been worked upon it, none could say — but its original virtue endured.",
    "Pulled from the fabric of Arda itself by a Maia who gave it physical form through an act of will that diminished them forever.",
    "Crafted beneath the waves of the Great Sea in a Telerin workshop that survived the Downfall of Númenor by being already underwater.",
    "Wrought during a conjunction of all visible stars by the last of the Noldorin smiths of Lindon, each component blessed by a different star's light.",
    "Forged in dragonfire — willingly given by one of the great wyrms — and cooled in the sacred springs of Ithilien. The dragon's name is inscribed in Cirth upon the hilt, though no one dares speak it.",
  ],
  "Legendary" => [
    "Forged in dragonfire by the last smith of Gondolin before the city fell, this artifact was meant to be a weapon against Morgoth himself. When Gondolin was destroyed, it was carried out by a survivor of the House of the Golden Flower. Kingdoms of Elves and Men have risen and fallen in the ages since, but this endures.",
    "Legend holds that a Vala walked Middle-earth in disguise and, moved by an act of extraordinary selflessness, left this behind as a gift. Those who have carried it speak of hearing whispers of guidance in the Elvish tongue during their darkest hours.",
    "This artifact was the final work of %{smith}, who spent forty years gathering materials from across Middle-earth and beyond. Upon completing it, they sailed West to Valinor. Some say the item consumed their art; others believe they departed knowing their work in Middle-earth was done.",
    "Wrought from wood of the White Tree and steel of Westernesse, this item has witnessed the rise and fall of every kingdom of Men since Númenor. Its surface bears the marks of countless battles, each one a chapter in the story of the Free Peoples.",
    "Created during %{event}, when the fate of Middle-earth hung in the balance. %{wielder} bore it as one chosen by destiny to stand against the Shadow. It absorbed power with each blow struck in that great conflict.",
    "Recovered from %{place} by %{wielder}, who spent years navigating deadly perils and ancient guardians. The quest cost the lives of many companions. The survivor emerged changed — bound to the artifact by something deeper than mere possession.",
    "Seven Elven-lords pooled their fëa — their spiritual essence — to create this artifact during %{event}. Each diminished themselves in the making, their memories and wisdom crystallized within the enchantment. The item sometimes speaks with their voices.",
    "This item was present when Sauron forged the One Ring in the Sammath Naur, and it absorbed a fragment of power as the Dark Lord's malice poured into his creation. The Ring wanted to corrupt it. It refused. Gandalf himself examined it and spoke only one word: 'Remarkable.'",
    "Forged by Aulë the Smith in the deeps of time and gifted to the eldest of the Dwarves. It passed through every great Dwarven kingdom — Khazad-dûm, Nogrod, Belegost, Erebor — before fate scattered it to the winds. Dwarves who see it weep, though they cannot explain why.",
    "Created by Celebrimbor himself, greatest of the Gwaith-i-Mírdain, in the years before Sauron revealed his treachery. It was hidden before Eregion fell and thus was never tainted by the Dark Lord's influence. The Three Rings are counted the greatest of the Elven-rings, but this was made with the same art.",
    "This artifact surfaced in %{place} after %{event}. %{wielder} bore it for a time, but ultimately surrendered it, writing in a letter preserved in Rivendell: 'It has done what it came to do through me. I am merely the latest in a chain that stretches back to the Elder Days.'",
    "Wrought from %{material} by %{smith} during %{era}. The creation required the willing gift of an Elf's immortal life, whose fëa was woven into the metal. On quiet nights, the item radiates a gentle warmth — the last echo of an Elven soul's compassion.",
  ],
  "Ancestral" => [
    "This artifact predates the Sun and Moon. It was wrought in the Years of the Trees, when the light of Telperion and Laurelin illuminated Valinor, and it still carries that light within it. Those who hold it see, for a fleeting instant, the world as it was before Morgoth marred it — green and golden and impossibly beautiful. The grief of that vision has broken the minds of lesser beings.",
    "Woven from the Music of the Ainur by Ilúvatar himself and placed in Arda as a thread of the Great Theme, this item was not created so much as it was always meant to exist. Every prophecy of the Eldar references it obliquely, and every great turning point in the history of Middle-earth can be traced back to its influence. It does not merely have a destiny; it IS destiny made tangible.",
    "Born in the Timeless Halls before Arda was made, forged from the Flame Imperishable that Ilúvatar alone can wield. When the Ainur sang the world into being, this item crystallized from the first chord of the Great Music — the moment creation became reality. Fëanor himself beheld it once and wept, for even the Silmarils were lesser works.",
    "The oldest beings in Arda — Círdan the Shipwright, Tom Bombadil, Treebeard — all remember a time when this item was already ancient. It carries within it the memory of the Void before Eä was spoken, the silence before the Music began. To wield it is to hold infinity in your hand.",
    "Created at the moment Ilúvatar spoke 'Eä!' and the world came into being, this artifact is simultaneously the first and last work of creation. Time bends in its presence. Heroes who have borne it describe experiencing the entire span of Arda's history in a single breath, from the Ainulindalë to the Dagor Dagorath that will end the world.",
    "The concept of this artifact exists in the thought of Ilúvatar, and therefore in every reality that could ever be. The Ainur sang it into being without knowing they did so, and Morgoth himself could not unmake it — for to destroy it would be to unravel the Theme of Ilúvatar, and not even the mightiest of the Valar can do that.",
    "This item was made in the Timeless Halls, where Ilúvatar dwells beyond the world. It passed through the Void into Arda at the singing of the Great Music, and it has been present at every great event since — the lighting of the Two Trees, the creation of the Silmarils, the forging of the Rings, the Downfall of Númenor, and the destruction of the One Ring. It is always there, at the hinge of fate, waiting.",
    "When Morgoth wove his discord into the Great Music, Ilúvatar turned even that evil to greater purpose. This item is the physical manifestation of that turning — darkness transmuted into something stronger than either good or evil alone. The Valar cannot fully comprehend it. Sauron feared it. Gandalf, alone among the wise, understood it — and he smiled.",
    "Fëanor, in the days of his greatness, once held this item and set it down without speaking. His sons asked what he had seen. 'The work of one greater than I,' he said — and Fëanor called no one his superior. It is the only recorded instance of Fëanor acknowledging a craft beyond his own.",
    "This artifact was old when Ungoliant devoured the Trees. It was ancient when Morgoth first descended into Arda. It was primordial when the Ainur first sang. It exists because Ilúvatar thought of it, and what Ilúvatar conceives cannot be unmade. The Noldor have a name for it in the High Speech: *Ainasúrë*, the Breath of the Holy Ones.",
    "The Red Book of Westmarch, in a passage attributed to Gandalf himself, contains this cryptic entry: 'There are things in Middle-earth older than Sauron, older than the Elves, older than the stones. This is one of them. It was not made — it always was. And when the world is unmade at the Last Battle, it will remain, for it belongs not to this world but to the One who imagined it.'",
  ],
}.freeze

# ── Effect descriptions — Middle-earth flavored ──
ME_EFFECT_DESCRIPTIONS = {
  "Attack Bonus" => [
    "guides strikes with the uncanny precision of an Elven warrior trained since the Years of the Trees",
    "hones the wielder's combat instincts as keen as Beleg Cúthalion's bow-arm — strikes land where mortal eyes cannot follow",
    "bends fate to favor deadly accuracy, as though the hand of Tulkas himself guides the blow",
    "whispers in the ancient battle-tongue of the Noldor, adjusting the wielder's form with each swing",
    "channels the battle-wisdom of the Eldar who fought Morgoth in the First Age, each stroke guided by millennia of war-craft",
    "strikes with the precision of Fingolfin before the gates of Angband, finding every weakness in the enemy's guard",
  ],
  "Attack Damage" => [
    "amplifies the destructive force of every blow, striking with the fury of Grond, the Hammer of the Underworld",
    "channels the elemental wrath of Ulmo's waves — the very air screams on impact",
    "tears through defenses as Anglachel tore through Glaurung's iron belly",
    "unleashes concussive bursts of force that echo like the fall of Thangorodrim",
    "strikes with the fury of a Balrog's whip, the impact rippling outward in waves of shadow and flame",
    "delivers blows that resonate through body and spirit alike, as the swords of the Noldor once did against the servants of Morgoth",
  ],
  "Defense" => [
    "creates an invisible barrier that deflects harm, shimmering like the Girdle of Melian",
    "hardens the air around the bearer into a ward as impenetrable as the walls of Gondolin",
    "absorbs the force of attacks before they land, dispersing the energy as starlight",
    "projects a lattice of protective runes in the Tengwar of the Noldor that flare when danger approaches",
    "surrounds the bearer in a shield of power like the defenses woven by the Elven-rings",
    "weaves a defense drawn from the same art that raised the Hidden City — a wall no enemy can see until they strike it",
  ],
  "Healing" => [
    "mends wounds with golden light that carries the fragrance of athelas, the kingsfoil",
    "accelerates the body's natural recovery, knitting flesh and bone as the hands of a true King of Gondor",
    "draws on the living force of Arda itself, the life that Yavanna breathed into growing things",
    "pulses with a heartbeat-rhythm that eases pain as Estë the Gentle eases weariness in the Gardens of Lórien",
    "channels the healing art of the Eldar, whose medicine surpasses mortal understanding",
    "heals with the same restorative power as the waters of the Mirrormere or the springs of Ithilien",
  ],
  "Material" => [
    "is wrought from a substance that defies understanding — lighter than mithril yet harder than the iron of Angband",
    "incorporates materials from beyond Middle-earth, their properties shifting with the phases of Ithil",
    "resonates with the inherent power of its exotic components, each gathered from a different corner of Arda",
    "was crafted from ore that fell from the sky, a star-fragment still carrying the cold fire of Varda's making",
    "is fashioned from %{material}, a substance that even the Noldorin loremasters struggle to classify",
    "bears the unmistakable hallmarks of Dwarf-craft — light as mithril, hard as the roots of the mountains",
  ],
  "Stealth" => [
    "bends light and shadow around the bearer, granting the invisibility of an Elven-cloak of Lórien",
    "wraps the wearer in silence and secrecy — even the keen ears of Elves lose the trail",
    "makes the bearer nearly imperceptible, like a Hobbit moving through the woods: unseen, unheard, barely there",
    "absorbs all sound and presence into an envelope of absolute stillness, as the Elves pass through the world unseen",
    "grants the shadow-craft of the Rangers of Ithilien, who moved as ghosts beneath the eaves of Mordor",
    "cloaks the wearer as thoroughly as the One Ring concealed its bearer — without the terrible cost",
  ],
  "Speed" => [
    "quickens the bearer's movements to a blur — swift as Oromë's steed Nahar across the plains of Valinor",
    "grants speed as though gravity were merely a suggestion, each stride covering the ground of three",
    "bestows preternatural swiftness that could outpace the arrows of the Galadhrim",
    "bends time slightly around the bearer, granting that extra heartbeat the Eldar use to slip between moments",
    "channels the speed of Shadowfax, lord of all horses, letting the bearer move as fast as thought",
    "grants the swiftness of the Eagles of Manwë, blurring between strides as though carried on the wind",
  ],
  "Protection" => [
    "wards against threats mortal and sorcerous, turning aside blade and dark magic with equal ease",
    "projects an aura of safety like the protection of the Elven-rings — danger simply forgets the bearer exists",
    "shields the bearer with ancient protective sigils in the Tengwar of Fëanor, each guarding against a different peril",
    "creates a sanctuary of peace within chaos, like the Hidden Valley of Rivendell where evil cannot easily enter",
    "radiates the protective blessing of Ulmo, Lord of Waters, whose care for the Children of Ilúvatar never wavered",
    "invokes the same art of concealment that hid Gondolin for centuries from the eyes of Morgoth",
  ],
  "Resistance" => [
    "fortifies the bearer against hostile forces, turning lethal power into mild discomfort",
    "renders the wearer resilient as the Dwarves whom Aulë made to endure, shrugging off what would break lesser folk",
    "provides enduring protection that learns from each assault, as a shield-wall of the Dúnedain adapts to every foe",
    "grants the legendary endurance of Húrin Thalion, who stood alone and unyielding against the hosts of Morgoth",
    "shields the bearer as completely as a wall of the Hornburg — steadfast and immovable",
  ],
  "Conjuration" => [
    "opens brief doorways through the fabric of Arda, through which glimpses of distant lands flash",
    "bends space as the Istari could, summoning what is needed from far away",
    "draws things through the unseen paths of Middle-earth, as messages travel by ways unknown to mortals",
    "rips holes in distance with the precision of the Palantíri, connecting two points across the width of the world",
    "draws upon the same power that opens the Doors of Durin — speak 'friend' and enter",
  ],
  "Flight" => [
    "grants the gift of flight, carried on wings of force as the Eagles of Manwë bear the worthy aloft",
    "defies the pull of the earth at the bearer's command, as naturally as the Elves walk upon snow",
    "lifts the wearer on currents of power, trailing motes of starlight like Eärendil across the heavens",
    "bestows flight as swift and sure as Thorondor, King of Eagles, whose wingspan shadowed the peaks of Thangorodrim",
    "harnesses the winds of Manwë, granting freedom of the skies that only the Great Eagles have known",
  ],
  "Frosting" => [
    "radiates bitter cold, as though the ice of the Helcaraxë still remembers the crossing of the Noldor",
    "sheaths itself in frost that never melts, cold as the peaks of the Misty Mountains in deepest winter",
    "can freeze the very air to ice, creating walls and bridges of crystal at the bearer's will",
    "channels the eternal winter of Forochel, the bitter cold of the far north where the Witch-king's realm once lay",
    "radiates the deathly cold of the Grinding Ice — the kind of cold that swallowed an army of Elves and left no trace",
  ],
  "Lightning" => [
    "crackles with the fury of a storm summoned by Manwë, Lord of the Winds",
    "calls down bolts of lightning as Gandalf once called flame upon the mountainside",
    "channels the raw power of thunder, arcing between enemies with devastating precision",
    "thunders with the voice of Oromë's great horn Valaróma, each discharge a tempest unleashed",
    "stores the lightning of the great storms that break upon Taniquetil, discharging it with the wrath of the Elder King",
  ],
  "Vision" => [
    "reveals what is hidden, as the Mirror of Galadriel shows things that were, things that are, and things that yet may be",
    "grants perception that pierces all disguise and darkness, as Elven-sight sees the unseen world",
    "opens the bearer's eyes to truths beyond mortal understanding; some report seeing the threads of fate that the Valar weave",
    "bestows sight as keen as the Palantíri, the Seeing Stones of Númenor — far-reaching and ever-watchful",
    "grants truesight sharper than the gaze of Sauron's Eye, piercing every veil and shadow",
  ],
  "Luck" => [
    "subtly tilts fortune in the bearer's favor, as the hidden purposes of Ilúvatar guide all things to their appointed end",
    "seems to attract fortunate happenings: doors left open, enemies looking the wrong way, storms clearing at the perfect moment",
    "bends probability as Gandalf would say: 'There are other forces at work in this world besides the will of evil'",
    "carries the peculiar luck of Hobbits — that inexplicable talent for being in exactly the right place at the right time",
    "radiates the kind of impossible fortune that brought Bilbo to Gollum's cave and the Ring to Frodo's hand",
  ],
  "Control" => [
    "grants dominion over the will of others, as the Rings of Power bound the Nine Kings of Men",
    "allows the wielder to sway minds, though unlike Sauron's art, it compels through persuasion rather than domination",
    "exerts an authority that few can resist — the commanding presence of one born to rule, like Aragorn before the Black Gate",
    "wields the power of command as the Istari do: not by force, but by a wisdom that makes obedience seem natural",
    "channels the voice of authority as Gandalf spoke to Théoden, breaking the spell of lesser wills",
  ],
  "Minding" => [
    "resonates with the thoughts of those nearby, as Galadriel could read the hearts of the Fellowship",
    "expands the bearer's awareness far beyond mortal limits, touching minds as the Eldar commune without words",
    "creates a bond between the wielder and the world, as the Ents know the thoughts of trees and stone",
    "opens the bearer's mind to the deep currents of thought that flow through Middle-earth like underground rivers",
    "connects the wielder to the unspoken knowledge of Arda, as Gandalf perceived truths hidden from lesser minds",
  ],
  "Summoning" => [
    "calls forth loyal servants, bound by ancient oaths sworn in the Elder Days",
    "summons allies as Gandalf summoned the Eagles — creatures come willingly, drawn by the artifact's authority",
    "opens channels to distant allies; those who answer speak of the item with reverence, as though it were a banner of old",
    "draws aid as a great horn draws warriors to battle — the call of Boromir's horn at Amon Hen, magnified a hundredfold",
    "commands the loyalty of beast and being through ancient bonds older than the Secondborn",
  ],
  "Enhance" => [
    "amplifies the bearer's natural gifts beyond mortal limits — a warrior becomes as the Eldar, a sage as the Istari",
    "infuses body and mind with surges of power that sharpen every sense and multiply every strength",
    "pushes every capability to its peak and beyond; the experience is described as briefly touching the power of the Ainur",
    "grants an enhancement like the might of the Dúnedain of old, whose lifespan and strength surpassed common Men",
    "elevates the bearer to the edge of what mortals can achieve — the boundary between Men and the Firstborn",
  ],
  "Utility" => [
    "provides a versatile array of useful enchantments that adapt to the bearer's need",
    "adapts to serve whatever the moment demands — as Gandalf always had the right tool, the right word, the right fire",
    "contains a wellspring of practical magic, each enchantment awakening intuitively when needed",
    "offers the kind of resourceful magic the Grey Pilgrim favored — subtle, practical, and endlessly useful",
    "functions with the ingenious precision of Dwarf-craft, solving problems its maker never imagined",
  ],
  "Understanding" => [
    "bridges all tongues and forms of speech, from the High Speech of the Noldor to the slow language of the Ents",
    "opens the mind to comprehend every written and spoken word, from ancient Quenya to the Black Speech of Mordor",
    "grants intuitive understanding beyond mere translation — the bearer reads intent, truth, and heart as Galadriel does",
    "bestows the gift of tongues as the Istari possessed it, making every language as familiar as the Common Speech",
  ],
  "Absortion" => [
    "hungrily devours hostile magic, as Ungoliant devoured the light of the Trees",
    "converts incoming power into stored energy, growing brighter with each spell it drinks",
    "creates a void that swallows enchantments as Shelob's darkness swallowed the light of Eärendil's star — though this serves a nobler purpose",
    "absorbs magic with the insatiable hunger of a Silmaril gathering light — every hostile spell feeds its reserves",
    "drinks in power as parched earth drinks rain, turning the enemy's greatest weapon into the bearer's greatest strength",
  ],
  "Saving Throws" => [
    "bolsters the bearer's will and endurance as the Dúnedain endure — unbowed by age, unbroken by hardship",
    "provides the mental fortitude of one who has looked upon the Silmarils and remained sane",
  ],
  "Initiative" => [
    "sharpens reflexes to Elven swiftness — the bearer acts before danger can materialize",
    "grants the battle-awareness of Glorfindel reborn — the bearer moves first, always, as one who has already seen death",
  ],
  "Inmunity" => [
    "grants absolute protection against specific harm, as mithril turns aside blade and dart",
    "renders the bearer utterly impervious, as a Balrog is immune to common flame",
  ],
}.freeze

ME_PERSONALITY_TRAITS = [
  "It hums a fragment of an Elvish song when danger approaches, the pitch rising as the threat draws near.",
  "It grows warm to the touch during moments of great emotion, as if sharing in its bearer's joy or grief.",
  "Those who carry it dream of places they have never seen — the shores of Valinor, the towers of Gondolin, the gardens of Lórien.",
  "It seems to resist being set aside, growing subtly heavier when put down, as if it fears being lost again.",
  "It glows with a faint Elven-light in the presence of Orcs, the light carrying the silver of Telperion.",
  "Animals react to it with awe — horses bow their heads, birds land on the bearer's shoulder, and wolves slink away.",
  "It smells faintly of athelas after being used, a fragrance that eases weariness and lifts the heart.",
  "Those nearby occasionally hear the distant sound of Elven singing, though no Elf walks within a hundred leagues.",
  "It trails faint motes of starlight when moved quickly, like the wake of Eärendil across the sky.",
  "Flowers bloom more swiftly in its presence, turning to face it as the mallorn trees turn toward Valinor.",
  "Its weight changes with the phases of the moon — featherlight under Ithil's full face, heavier in the dark of the moon.",
  "It occasionally whispers fragments of Quenya, the High Speech of the Noldor, as though remembering conversations from another age.",
  "Water near it becomes pure and sweet, and food consumed in its presence sustains twice as long, like Lembas.",
  "It casts a shadow unlike its own shape — the shadow of something grander, as though it remembers a greater form.",
  "Flames lean toward it as campfires lean toward the Elves, and hearths burn longer in its proximity.",
  "The Tengwar inscribed upon it shift and rearrange when none observe, telling a different tale each time they are read.",
  "Compasses spin erratically near it, their needles ultimately pointing toward the West — always toward the West.",
  "The bearer's reflection in still water appears wearing armor of an ancient style, as if showing a previous bearer.",
  "Touching it for the first time triggers a vivid flash of memory — not the bearer's own, but a fragment of an Elder Day.",
  "It resonates with a deep note during thunderstorms, answering the voice of Manwë across the sky.",
  "Elven-sight reveals it burning far brighter than it should — like a captured star, compressed into mortal form.",
  "It sings a barely audible chord when brought near other objects of power, as instruments harmonize in an orchestra.",
  "The air around it is always comfortable, regardless of weather — a small echo of the Blessed Realm's eternal spring.",
  "Those who hold it long develop an instinctive sense of direction, always knowing the way West toward the Sea.",
  "It leaves a faint afterimage, as though reality needs a moment to remember where it is.",
  "Growing things flourish in its presence — grass grows greener, flowers open, and dead wood puts forth new leaves.",
  "In complete darkness it emits just enough light to see by — the exact amount needed, no more, no less.",
  "The bearer develops an inexplicable longing for the Sea, the same yearning the Elves call the 'Sea-longing.'",
  "Zones of corrupted magic — the influence of Mordor, of barrow-wights — calm in its presence, as sunlight burns away fog.",
  "It hums a unique melody for each person who touches it, as though it remembers a song composed for their soul alone.",
].freeze

ME_DRAMATIC_CLOSINGS = [
  "Many have sought to possess it; few have proven worthy. The rest were forgotten by history — and by the item.",
  "Its true potential, the wise warn, has yet to be fully awakened — and what will happen when it does may reshape Middle-earth.",
  "Those who wield it speak of a burden heavier than the item's weight, for it demands as much as it gives — as all great things do.",
  "It is said that the item chooses its bearer, as Gandalf said of the Ring: 'It was not Gollum, but the Ring itself that decided things.'",
  "Legends claim it will be carried at the Dagor Dagorath, the Last Battle at the end of the world, when Morgoth returns from the Void.",
  "Every age produces a hero destined to carry it — and a servant of darkness destined to covet it. The cycle has never been broken.",
  "Its story is far from over. If anything, as Gandalf might say, the tale has only just begun.",
  "Some believe destroying it would unmake a part of Arda itself. Others believe that is precisely why it must one day be destroyed.",
  "The last three bearers perished within a year of claiming it. Whether by fate, curse, or willing sacrifice, the Wise do not say.",
  "When the bearer sleeps, the item dreams for them — showing visions of the Elder Days, of the world's making, and of what may yet come to pass.",
  "Gandalf held it once, briefly, and set it down with the words: 'Not for me. My task is otherwise.'",
  "Elrond has recorded it in the annals of Rivendell with the same notation given to the Rings of Power: 'Handle with the utmost care.'",
  "The keepers of the Red Book have dedicated a separate volume to accounts of this item. It is kept in a locked case in the Thain's study.",
  "Those who have wielded it and survived — precious few — describe the experience as 'hearing the Music of the Ainur and knowing your part in it.'",
  "In the end, it will outlast its bearer, as it has outlasted every bearer since the Elder Days. It is patient. It endures. It waits for the one who is meant to carry it last.",
  "Sauron once sought it. He failed. That alone should tell you everything you need to know about its power.",
].freeze

ME_EFFECT_TRANSITIONS = [
  "Its most remarkable property is that it",
  "Those who have studied it in the libraries of Rivendell note that it",
  "Beyond its physical form, it",
  "In battle, it",
  "When called upon, it",
  "More wondrous still, it",
  "Its enchantment ensures that it",
  "In the hands of a worthy bearer, it",
  "Perhaps most notably, it",
  "As if that were not enough, it also",
  "Veterans of the great wars who have borne it confirm that it",
  "The loremasters of Rivendell have documented that it",
  "Rangers of the Dúnedain who have carried it report that it",
  "According to those who have witnessed it wielded in anger, it",
  "What truly sets it apart from lesser works is that it",
].freeze

ME_HISTORICAL_ANECDOTES = [
  "It once saved the life of %{wielder} during %{event}, turning a certain doom into an improbable victory.",
  "Records in the library of Rivendell mention it by a different name in each Age, as though it reinvents itself.",
  "%{wielder} bore it for many years before passing it on, saying simply: 'Its work through me is done.'",
  "A guild of thieves in Bree once placed a bounty on it — the contract was never fulfilled, and the guild no longer exists.",
  "It was thought lost during %{event}, but resurfaced decades later in the possession of a Hobbit who said they found it 'just lying about, as if waiting.'",
  "Three kingdoms of Men have listed it among their crown treasures, though it has never rested in any vault for long.",
  "Gandalf examined it and said only: 'Be careful with that. It is older than it looks, and it looks very old indeed.'",
  "During %{event}, it is said to have acted of its own will, protecting its bearer from a blow they never saw.",
  "%{wielder} used it to survive the Battle of Five Armies, when other arms shattered against the Orc-host.",
  "It was last seen in %{place} before %{event}, after which it vanished from the annals of the Wise for three hundred years.",
  "%{organization} tracked its movements across Middle-earth for decades with obsessive care.",
  "Bilbo wrote a verse about it in Rivendell, but Gandalf asked that it be removed from the final manuscript. The argument lasted a week.",
  "The Dúnedain attempted to secure it during %{event}, but %{wielder} had already vanished into the Wild.",
  "It passed through the markets of Dale seven times in a single day before vanishing with a traveler heading East.",
  "During the siege of Erebor, %{wielder} used it to hold the gate against a hundred Orcs — a deed the Dwarves still sing of.",
  "A sorcerer of the East attempted to study its enchantments and was found the next morning alive but unable to work any magic at all.",
  "%{wielder} brought it to %{place}, where it resonated with the ancient power of that land so strongly that the very stones hummed.",
  "It was offered as tribute to Smaug the Golden. The dragon examined it, returned it, and told the trembling ambassador: 'Keep it. I have no use for things I cannot eat — but you may.'",
].freeze

# ══════════════════════════════════════════════════════════════════
# MIDDLE-EARTH INSERTS
# ══════════════════════════════════════════════════════════════════
puts "  Seeding Middle-earth lore..."
lt = "middle_earth"
lore_insert_hash(lt, "prefix",               ME_PREFIXES)
lore_insert_hash(lt, "category_title",       ME_CATEGORY_TITLES)
lore_insert(lt,      "suffix",               ME_SUFFIXES)
lore_insert(lt,      "simple_suffix",        ME_SIMPLE_SUFFIXES)
lore_insert(lt,      "smith",                ME_LEGENDARY_SMITHS)
lore_insert(lt,      "wielder",              ME_LEGENDARY_WIELDERS)
lore_insert(lt,      "place",                ME_LEGENDARY_PLACES)
lore_insert(lt,      "event",                ME_LEGENDARY_EVENTS)
lore_insert(lt,      "deity",                ME_DEITIES)
lore_insert(lt,      "organization",         ME_ORGANIZATIONS)
lore_insert(lt,      "material",             ME_EXOTIC_MATERIALS)
lore_insert(lt,      "age",                  ME_AGES_AND_ERAS)
lore_insert(lt,      "curse",                ME_CURSES_AND_QUIRKS)
lore_insert(lt,      "prophecy",             ME_PROPHECIES)
lore_insert(lt,      "personality_trait",    ME_PERSONALITY_TRAITS)
lore_insert(lt,      "dramatic_closing",     ME_DRAMATIC_CLOSINGS)
lore_insert(lt,      "effect_transition",    ME_EFFECT_TRANSITIONS)
lore_insert(lt,      "historical_anecdote",  ME_HISTORICAL_ANECDOTES)
lore_insert_hash(lt, "origin",               ME_ORIGINS)
lore_insert_hash(lt, "effect_description",   ME_EFFECT_DESCRIPTIONS)
# Middle-earth shares effect_flavor with Faerun
lore_insert_hash(lt, "effect_flavor",        EFFECT_FLAVOR)

LoreEntry.clear_cache! if LoreEntry.respond_to?(:clear_cache!)
puts "Lore Data entries: #{LoreEntry.where.not(category: 'proper_name').count}"
