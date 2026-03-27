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
    "Common"    => %w[Worn Sturdy Rustic Humble Steady Simple Honest Faithful Trusted Tempered],
    "Uncommon"  => %w[Keen Glinting Blessed Warden's Vigilant Stalwart Noble Radiant Swift Valiant],
    "Rare"      => %w[Arcane Runed Enchanted Mystic Phantom Spectral Hallowed Infernal Crimson Emerald],
    "Very Rare" => %w[Astral Void-touched Planar Eldritch Ethereal Abyssal Celestial Draconic Shadow-forged Soul-bound],
    "Legendary" => %w[Godslayer World-ender Titan's Doom-forged Immortal Sovereign Apocalyptic Eternal Mythic Exalted],
    "Ancestral" => %w[Primordial Cosmic Genesis Origin World-seed First-forged Timeless Infinite Ur-ancient Boundless],
  }.freeze

  CATEGORY_TITLES = {
    "Weapons"    => %w[Blade Edge Fang Wrath Fury Vengeance Reckoning Judgment],
    "Armor"      => %w[Bulwark Bastion Aegis Ward Rampart Fortress Sentinel Shell],
    "Shields"    => %w[Wall Guardian Barrier Ward Buckler Defender Protector Vigil],
    "Potions"    => %w[Elixir Brew Draught Tincture Philter Essence Vial Ichor],
    "Scrolls"    => %w[Codex Tome Script Decree Sigil Glyph Mandate Writ],
    "Rings"      => %w[Band Circle Loop Signet Circlet Seal Coil Ring],
    "Amulets"    => %w[Talisman Pendant Charm Locket Medallion Token Emblem Jewel],
    "Wands"      => %w[Rod Scepter Baton Focus Wand Conduit Channeler Beacon],
    "Staffs"     => %w[Pillar Spire Rod Crook Staff Scepter Mace Stave],
    "Boots"      => %w[Treads Striders Walkers Greaves Steps Runners Kicks Sabatons],
    "Gloves"     => %w[Grasp Clutch Grip Gauntlets Mitts Hands Fists Touch],
    "Helms"      => %w[Crown Visor Casque Crest Diadem Helm Mantle Pinnacle],
    "Cloaks"     => %w[Shroud Mantle Veil Cape Drape Cloak Shadow Wrap],
    "Books"      => %w[Grimoire Lexicon Codex Compendium Chronicle Almanac Opus Volume],
    "Gems"       => %w[Prism Shard Crystal Jewel Stone Heart Eye Tear],
  }.freeze

  EFFECT_FLAVOR = {
    "Attack Bonus"   => %w[Striking Cleaving Smiting Piercing Slashing],
    "Attack Damage"  => %w[Blazing Frozen Thundering Withering Searing],
    "Defense"        => %w[Warding Shielding Fortifying Guarding Bolstering],
    "Healing"        => %w[Mending Restoring Renewing Reviving Soothing],
    "Material"       => %w[Adamantine Mithral Orichalcum Starmetal Moonsilver],
    "Stealth"        => %w[Shadowed Silent Unseen Phantom Veiled],
    "Speed"          => %w[Swift Hastened Quicksilver Windborne Blurring],
    "Protection"     => %w[Blessed Hallowed Sanctified Consecrated Empowered],
    "Resistance"     => %w[Resilient Unyielding Impervious Unbreakable Enduring],
    "Conjuration"    => %w[Summoner's Invoker's Caller's Conjurer's Binder's],
    "Flight"         => %w[Soaring Skybound Winged Ascending Levitating],
    "Frosting"       => %w[Glacial Frostbitten Frozen Winterborn Icebound],
    "Lightning"      => %w[Thunderstruck Stormborn Voltaic Tempest Crackling],
    "Vision"         => %w[All-seeing Eagle-eyed Truesight Perceptive Vigilant],
    "Luck"           => %w[Fortunate Fated Destined Charmed Blessed],
    "Control"        => %w[Dominating Commanding Bending Ruling Binding],
    "Minding"        => %w[Psionic Telepathic Thought-born Mind-forged Cerebral],
    "Summoning"      => %w[Caller's Invoker's Harbinger's Beckoning Spiritbound],
    "Enhance"        => %w[Empowered Augmented Ascendant Transcendent Fortified],
    "Utility"        => %w[Versatile Ingenious Resourceful Practical Clever],
    "Understanding"  => %w[Omnilingual Polyglot Worldly Learned Sage],
    "Absortion"      => %w[Devouring Consuming Absorbing Nullifying Siphoning],
  }.freeze

  SUFFIXES = [
    "of the Fallen King", "of Endless Night", "of the Dawn", "of Shattered Realms",
    "of the Iron Throne", "of Lost Souls", "of the Phoenix", "of the Deep",
    "of the Crimson Moon", "of Winter's Grasp", "of the Storm Lord",
    "of the Ancient Pact", "of the Forgotten Age", "of the Wild Hunt",
    "of the Void Walker", "of Dragon's Breath", "of the Astral Sea",
    "of the Blood Oath", "of the Eternal Flame", "of Starfall",
    "of the Last Bastion", "of the Shadow Weave", "of Titan's Wrath",
    "of the Feywild", "of the Nine Hells", "of the Arcane Eye",
  ].freeze

  SIMPLE_SUFFIXES = [
    "of Power", "of Might", "of Valor", "of Grace", "of Fury",
    "of Wisdom", "of Fortune", "of Warding", "of Binding", "of Ruin",
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
  # DESCRIPTION GENERATION
  # ══════════════════════════════════════════════════════

  # ── Named characters that appear in stories ──
  LEGENDARY_SMITHS = [
    "Torvald the Ash-Handed", "Morwen Brightforge", "Kael'thas Ironvein",
    "Sister Elara of the Embers", "the blind dwarf Grundar", "Vaelith the Wandering Artisan",
    "the reclusive gnome Fizzwick", "Master Hendrick of Anvil's Rest",
    "the dragonborn smith Kriv Steelscale", "Orin Half-Giant",
  ].freeze

  LEGENDARY_WIELDERS = [
    "the paladin Serena Dawnshield", "warlord Thane Drakov",
    "the elven ranger Lirael Starbow", "archmage Verenthos the Unbound",
    "General Kira Stonefist", "the tiefling rogue Malachar",
    "High Priestess Ysolde", "the half-orc champion Grukk Ironjaw",
    "the drow exile Zaelen Nightwhisper", "Sir Aldric of the Silver Dawn",
    "Queen Thessara the Undying", "the monk Haru of the Broken Path",
  ].freeze

  LEGENDARY_PLACES = [
    "the Forge of Falling Stars", "Mount Pyratheon's caldera",
    "the Sunken Temple of Vel'koz", "the Crystalline Caverns of Aethon",
    "the ruins of the Sky Citadel", "the Abyssal Rift of Xar'nath",
    "the Feywild crossing at Moonhollow", "the Dragonbone Wastes",
    "the Frozen Throne of Ithkar", "the Whispering Observatory",
    "the Tomb of the First Emperor", "the Living Dungeon of Morpheus",
  ].freeze

  LEGENDARY_EVENTS = [
    "the Siege of Ashenmoor", "the Night of Falling Stars",
    "the Sundering of the Veil", "the War of Broken Crowns",
    "the Dragon Conclave of the Third Age", "the Plague of Shadows",
    "the Great Convergence", "the Betrayal at Silver Gate",
    "the Battle of the Bleeding Fields", "the Eclipse of Empires",
    "the Pact of Eternal Flame", "the Cataclysm of the Weeping God",
  ].freeze

  # ── Origins per rarity ──
  ORIGINS = {
    "Common" => [
      "Crafted by a village smith as part of a modest commission.",
      "Assembled from quality materials by a traveling artisan.",
      "Produced in a guild workshop following time-tested methods.",
      "Fashioned during a quiet winter by a seasoned craftsperson.",
      "Bought from a market stall in a busy trade town, its previous owner unknown.",
      "Salvaged from an abandoned outpost and restored with care.",
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
    ],
    "Rare" => [
      "Forged in the crucible of a war between two rival mage guilds, its enchantments a byproduct of their fierce competition.",
      "Plucked from the dreams of a sleeping archmage by a daring planar thief.",
      "Crafted by dwarven runesmiths deep within the Undermountain, quenched in water from an underground lake that glows with bioluminescent fungi.",
      "Recovered from the tomb of a forgotten general whose conquests once reshaped the borders of three kingdoms.",
      "Imbued with power during a rare celestial alignment that occurs only once every century.",
      "Salvaged from the wreckage of a spelljammer that crashed into the Sea of Fallen Stars, still humming with residual astral energy.",
      "Forged by #{LEGENDARY_SMITHS.sample} during a fevered three-day vision quest, the design revealed by a spirit of the forge.",
      "Discovered inside a geode of pure arcane crystal in the Underdark, as if the stone had grown around it over millennia.",
    ],
    "Very Rare" => [
      "Forged in the heart of a dying star by an astral smith who bargained with the fabric of reality itself. The metal still carries the faint warmth of stellar fire.",
      "Pulled from the petrified hand of an ancient hero whose statue has stood at a crossroads for a thousand years, slowly accumulating ambient magic from every spell cast nearby.",
      "Created during the Sundering, when the barriers between planes thinned and raw magical energy flooded the mortal realm. Its creator sacrificed their sight to complete the work.",
      "Assembled from fragments of three legendary artifacts, each destroyed in a different age. The echoes of their former power resonate within this new form.",
      "Born from the last breath of a phoenix that chose not to be reborn, pouring its eternal flame into mortal craft instead.",
      "Shaped by #{LEGENDARY_SMITHS.sample} in #{LEGENDARY_PLACES.sample}, where the boundary between the Material Plane and the Shadowfell is thin as parchment. Shadows still cling to its surface when the light is right.",
      "This artifact was the spoils of #{LEGENDARY_EVENTS.sample}. #{LEGENDARY_WIELDERS.sample} claimed it from the battlefield, though some say it chose its bearer rather than the other way around.",
      "Grown — not forged — in a garden tended by archfey, where metal blooms like flowers and gems ripen on crystalline vines. The process took seven mortal lifetimes.",
    ],
    "Legendary" => [
      "Forged in dragonfire by the last of the Titan-smiths, this artifact was meant to seal a rift between the mortal world and the Abyss. When the rift closed, the item remained — forever touched by the darkness it contained. Kingdoms have risen and fallen in wars fought over its possession.",
      "Legend holds that a god walked the mortal realm disguised as a beggar and, moved by an act of extraordinary kindness, left this item behind as a gift. Those who have carried it report hearing whispers of divine guidance in their darkest hours, though the god has never returned to claim it.",
      "This artifact was the final work of #{LEGENDARY_SMITHS.sample}, who spent forty years gathering materials from every known plane of existence. Upon completing it, they vanished without a trace. Some say the item consumed them; others believe they ascended to a higher plane of existence.",
      "Carved from the heartwood of the World Tree by elven artificers during the First Age, this item has witnessed the rise and fall of every civilization since. Its surface bears the scratches and marks of countless battles, each one a chapter in the story of the world.",
      "Created during #{LEGENDARY_EVENTS.sample}, when the gods themselves took up arms. #{LEGENDARY_WIELDERS.sample} wielded it as a mortal champion chosen by fate to fight alongside divine beings. It absorbed fragments of godly power with each blow struck in that cosmic conflict.",
      "Recovered from #{LEGENDARY_PLACES.sample} by #{LEGENDARY_WIELDERS.sample}, who spent a decade navigating the deadly traps and ancient guardians that protected it. The expedition cost the lives of thirty companions. The survivor emerged changed — older, wiser, and bound to the artifact by something deeper than ownership.",
      "Seven archmages pooled their life force to create this artifact during #{LEGENDARY_EVENTS.sample}. Each mage died upon completing their contribution, their final thoughts and memories crystallized within the enchantment. The item sometimes speaks with their voices.",
    ],
    "Ancestral" => [
      "This artifact predates the gods themselves. Ancient texts speak of it as a fragment of the primordial force that shaped reality — a sliver of pure creation given form. It existed before language, before thought, before the first star ignited in the void. Those who hold it feel the weight of eternity pressing against their consciousness, the echo of a universe being born.",
      "Woven from the threads of fate by the Three Sisters who sit beyond time itself, this item was placed in the mortal world as a test — or perhaps a gift. Every prophecy ever spoken references it obliquely, and every great turning point in history can be traced back to its influence. It does not merely exist within destiny; it IS destiny made manifest.",
      "Born in the space between heartbeats of the Sleeping God, forged from the boundary between existence and oblivion. When the universe was young and formless, this item crystallized from the first act of will — the moment consciousness emerged from chaos. Scholars who study it too closely report that the boundaries of their own reality begin to blur.",
      "The oldest beings in existence — the primordial dragons, the elder elementals, the first fey — all remember a time when this item was already ancient. It carries within it the memory of a universe that existed before this one, a cosmos that collapsed so that ours might be born. To wield it is to touch infinity.",
      "Created at the exact moment the multiverse came into being, this artifact is simultaneously the first and last thing that will ever exist. Time flows differently in its presence. Heroes who have carried it describe experiencing their entire lifetime in a single breath, only to find that centuries have passed in the outside world.",
      "The concept of this artifact exists in every reality simultaneously. In each universe, a version manifests differently, but the core essence — the primordial spark of creation — remains identical. Sages theorize that if every version were brought together, reality itself would fold inward. None have dared attempt it.",
    ],
  }.freeze

  # ── Rich effect narrative fragments ──
  EFFECT_DESCRIPTIONS = {
    "Attack Bonus" => [
      "guides strikes with supernatural precision, as if an invisible hand corrects the arc of every swing",
      "hones the wielder's combat instincts to a razor edge — strikes land where the eye cannot follow",
      "bends probability to favor deadly accuracy; opponents speak of blows that arrive before they can react",
      "whispers targeting adjustments directly into the wielder's muscle memory",
    ],
    "Attack Damage" => [
      "amplifies the destructive force of every blow, turning glancing hits into devastating wounds",
      "channels raw elemental fury into each strike — the air itself screams on impact",
      "tears through defenses with devastating power, leaving wounds that resist magical healing",
      "unleashes concussive bursts of force that echo through armor and bone alike",
    ],
    "Defense" => [
      "creates an invisible barrier that deflects incoming harm, shimmering faintly when struck",
      "hardens the air around the bearer into a shimmering ward that reacts faster than thought",
      "absorbs the kinetic force of attacks before they land, dispersing the energy as harmless light",
      "projects a lattice of protective runes that flare to life when danger approaches",
    ],
    "Healing" => [
      "mends wounds with warm, golden light that smells faintly of spring rain",
      "accelerates the body's natural recovery, knitting torn flesh and mending broken bone in moments",
      "draws on ambient life energy to restore vitality, leaving the surrounding grass greener and flowers taller",
      "pulses with a gentle heartbeat-like rhythm that synchronizes with the bearer's own, slowly washing away pain and fatigue",
    ],
    "Material" => [
      "is wrought from a substance that defies conventional metallurgy — it is lighter than steel yet harder than adamantine",
      "incorporates materials from beyond the mortal realm, their properties shifting subtly with the phases of the moon",
      "resonates with the inherent magic of its exotic components, each one gathered from a different plane of existence",
      "was crafted from ore that fell from the sky during a meteor shower, still carrying trace amounts of stellar energy",
    ],
    "Stealth" => [
      "bends light and sound around the bearer, making them little more than a suggestion in the corner of one's eye",
      "wraps the user in a cloak of silence and shadow — even dogs lose the scent",
      "makes the bearer nearly invisible to mundane senses; only the most perceptive notice a faint distortion, like heat rising from summer stone",
      "absorbs the bearer's footfalls, breath, and even heartbeat into an envelope of absolute stillness",
    ],
    "Speed" => [
      "quickens the bearer's movements to a blur — witnesses describe a streak of color where a person should be",
      "lets the user move as if gravity were merely a suggestion, each stride covering impossible ground",
      "grants bursts of preternatural swiftness that can outpace an arrow in flight",
      "bends time slightly around the bearer, giving them an extra heartbeat to react when others would freeze",
    ],
    "Protection" => [
      "wards against magical and mundane threats alike, turning aside blade and spell with equal ease",
      "projects an aura of safety that turns aside danger — arrows veer, spells fizzle, and blades skid along invisible curves",
      "shields the bearer with ancient protective sigils that activate independently, each one guarding against a different school of harm",
      "creates a sanctuary of calm within chaos; allies standing near the bearer report feeling unnaturally safe, as if the world's dangers simply forget they exist",
    ],
    "Resistance" => [
      "fortifies the bearer against hostile energies, turning lethal forces into mild discomfort",
      "renders the user resilient to forces that would break lesser beings, shrugging off attacks that should be fatal",
      "provides enduring protection against specific forms of harm — the enchantment learns from each assault, growing stronger with experience",
    ],
    "Conjuration" => [
      "opens brief portals to other planes of existence, through which glimpses of alien landscapes flash",
      "can summon objects or creatures from distant realms, drawn by the bearer's focused will",
      "bends the fabric of space to bring forth what is needed, though the portals occasionally admit things that were not invited",
    ],
    "Flight" => [
      "grants the gift of soaring through the skies, carried on wings of shimmering force",
      "defies gravity at the bearer's command, allowing movement in three dimensions as naturally as walking",
      "lifts the user on currents of magical force, leaving a trail of faintly glowing motes in their wake",
    ],
    "Frosting" => [
      "radiates an aura of bitter, biting cold that turns breath to fog and water to ice within arm's reach",
      "sheaths itself in a layer of never-melting ice, cold enough to numb on contact",
      "can freeze the very moisture from the air, creating walls, bridges, or prisons of crystalline ice at the bearer's command",
    ],
    "Lightning" => [
      "crackles with barely contained electrical fury — the bearer's hair stands on end, and small objects levitate nearby",
      "calls down bolts of lightning at the wielder's command, each one leaving the acrid taste of ozone",
      "channels the raw power of the storm, arcing between enemies with calculated, devastating precision",
    ],
    "Vision" => [
      "reveals what is hidden from ordinary sight — invisible creatures shimmer, illusions dissolve, and the truth stands naked",
      "grants perception that pierces illusion and darkness, extending sight into the ethereal plane",
      "opens the bearer's eyes to truths beyond mortal ken; some who use it report seeing the threads of fate that bind all living things",
    ],
    "Luck" => [
      "subtly tilts fortune in the bearer's favor — coins land heads-up, dice roll high, and traps misfire at critical moments",
      "seems to attract fortunate coincidences: doors left unlocked, guards looking the wrong way, storms clearing just in time",
      "bends probability in small but meaningful ways; over time, the cumulative effect is like having an invisible guardian angel",
    ],
    "Control" => [
      "grants dominion over the will of others, bending minds like a blacksmith bends iron",
      "allows the wielder to bend minds to their purpose — the affected rarely realize their thoughts are not their own",
      "exerts an irresistible force of command; even those who resist report a crushing weight of authority pressing against their consciousness",
    ],
    "Minding" => [
      "resonates with the thoughts of those nearby, creating a web of awareness that extends in every direction",
      "expands the bearer's mental reach far beyond normal limits, touching minds miles away",
      "creates a psychic link between the wielder and the world around them; animals, plants, and even stones whisper their secrets",
    ],
    "Summoning" => [
      "can call forth loyal servants from other planes, bound by ancient pacts older than mortal memory",
      "binds extraplanar beings to temporary service — they come willingly, drawn by the artifact's reputation among the outer planes",
      "opens channels to realms populated by willing allies; the summoned creatures speak of the artifact with reverence",
    ],
    "Enhance" => [
      "amplifies the bearer's natural abilities beyond mortal limits — a strong warrior becomes a titan, a quick rogue becomes a phantom",
      "infuses the body and mind with surges of magical energy that sharpen every sense and multiply every strength",
      "pushes physical and mental capabilities to their absolute peak, then beyond; the experience is described as briefly touching the divine",
    ],
    "Utility" => [
      "provides a versatile array of practical magical functions that adapt to the situation at hand",
      "adapts to serve whatever need the moment demands — a tool, a shelter, a light in darkness",
      "contains a wellspring of useful enchantments, each one activating intuitively when the need arises",
    ],
    "Understanding" => [
      "bridges the gap between all languages and forms of communication, including the silent speech of animals and the slow language of trees",
      "opens the mind to comprehend any spoken or written word, from ancient dead tongues to the mathematical language of the universe itself",
      "grants intuitive understanding of meaning beyond mere words — the bearer can read intent, deception, and emotion as easily as text on a page",
    ],
    "Absortion" => [
      "hungrily devours hostile magic directed at the bearer, converting it into raw energy that crackles across its surface",
      "converts incoming magical energy into usable power, growing visibly brighter with each spell it absorbs",
      "creates a void that swallows spells before they can take effect — enemy casters describe the sensation as trying to light a fire underwater",
    ],
  }.freeze

  # ── Personality traits ──
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
  ].freeze

  # ── Historical anecdotes for mid-tier+ items ──
  HISTORICAL_ANECDOTES = [
    "It once saved the life of %{wielder} during %{event}, turning a certain defeat into an improbable victory.",
    "Records in the library of Candlekeep mention it by a different name, suggesting it has reinvented itself across the centuries.",
    "%{wielder} carried it for seventeen years before passing it on, claiming it had 'finished what it came to do.'",
    "A thieves' guild in Waterdeep once placed a bounty of ten thousand gold on it — the contract was never fulfilled.",
    "It was thought lost during %{event}, but resurfaced decades later in the possession of a child who claimed to have found it 'waiting for them' in a forest.",
    "Three separate kingdoms list it among their crown treasures, though it has not rested in any vault for long.",
    "The sage Elminster is said to have examined it and spoken only two words: 'Be careful.'",
    "During %{event}, it is said to have acted of its own accord, protecting its bearer from a blow they never saw coming.",
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

  # ── Common: 1-2 sentences, functional and grounded ──
  def self.build_simple_description(item_word, effect_types)
    origin = ORIGINS["Common"].sample
    desc = "A reliable #{item_word} of honest craftsmanship. #{origin}"
    if effect_types.any?
      effect_desc = EFFECT_DESCRIPTIONS[effect_types.first]&.sample
      desc += " It #{effect_desc}." if effect_desc
    end
    desc
  end

  # ── Uncommon: 2-3 sentences, hint of story and character ──
  def self.build_uncommon_description(rarity_name, item_word, effect_types)
    origin = ORIGINS[rarity_name].sample
    desc = "An unusual #{item_word} that stands apart from ordinary craftsmanship. #{origin}"
    if effect_types.any?
      transition = EFFECT_TRANSITIONS.sample
      effect_desc = EFFECT_DESCRIPTIONS[effect_types.first]&.sample
      desc += " #{transition} #{effect_desc}." if effect_desc
    end
    desc += " #{PERSONALITY_TRAITS.sample}" if rand < 0.5
    desc
  end

  # ── Rare: 3-5 sentences with backstory and anecdotes ──
  def self.build_rare_description(rarity_name, item_word, effect_types, power)
    origin = ORIGINS[rarity_name].sample
    desc = "A remarkable #{item_word} that radiates quiet power. #{origin}"

    effect_types.first(2).each_with_index do |et, i|
      transition = EFFECT_TRANSITIONS.sample
      effect_desc = EFFECT_DESCRIPTIONS[et]&.sample
      desc += " #{transition} #{effect_desc}." if effect_desc
    end

    # Add a historical anecdote
    if rand < 0.6
      anecdote = HISTORICAL_ANECDOTES.sample
      anecdote = anecdote.gsub("%{wielder}", LEGENDARY_WIELDERS.sample)
                         .gsub("%{event}", LEGENDARY_EVENTS.sample)
      desc += " #{anecdote}"
    end

    desc += " #{PERSONALITY_TRAITS.sample}"
    desc
  end

  # ── Very Rare: 4-6 sentences, rich narrative with named characters ──
  def self.build_elaborate_description(rarity_name, item_word, effect_types, power)
    origin = ORIGINS[rarity_name].sample
    desc = origin.dup

    # Weave in effect descriptions with varied transitions
    transitions_used = EFFECT_TRANSITIONS.shuffle
    effect_types.first(3).each_with_index do |et, i|
      effect_desc = EFFECT_DESCRIPTIONS[et]&.sample
      if effect_desc
        transition = transitions_used[i] || EFFECT_TRANSITIONS.sample
        desc += " #{transition} #{effect_desc}."
      end
    end

    # Historical depth
    anecdote = HISTORICAL_ANECDOTES.sample
    anecdote = anecdote.gsub("%{wielder}", LEGENDARY_WIELDERS.sample)
                       .gsub("%{event}", LEGENDARY_EVENTS.sample)
    desc += " #{anecdote}"

    # Personality
    traits = PERSONALITY_TRAITS.shuffle.first(rand(1..2))
    traits.each { |t| desc += " #{t}" }
    desc
  end

  # ── Legendary & Ancestral: Full epic lore, 6+ sentences with deep history ──
  def self.build_epic_description(rarity_name, item_word, effect_types, power)
    origin = ORIGINS[rarity_name].sample
    desc = origin.dup

    # Rich effect narrative with varied transitions
    transitions_used = EFFECT_TRANSITIONS.shuffle
    effect_types.each_with_index do |et, i|
      effect_desc = EFFECT_DESCRIPTIONS[et]&.sample
      if effect_desc
        transition = transitions_used[i] || EFFECT_TRANSITIONS.sample
        desc += " #{transition} #{effect_desc}."
      end
    end

    # Multiple historical anecdotes for epic depth
    anecdotes = HISTORICAL_ANECDOTES.shuffle.first(2)
    anecdotes.each do |anecdote|
      filled = anecdote.gsub("%{wielder}", LEGENDARY_WIELDERS.sample)
                       .gsub("%{event}", LEGENDARY_EVENTS.sample)
      desc += " #{filled}"
    end

    # Multiple personality traits
    traits = PERSONALITY_TRAITS.shuffle.first(rand(2..3))
    traits.each { |t| desc += " #{t}" }

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
