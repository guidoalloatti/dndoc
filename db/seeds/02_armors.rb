puts "Creating Armors..."
Armor.create([
  # Light Armor
  { name: "Padded",          armor_type: "Light",  armor_class: "11 + Dex mod",              cost: 5,    weight: 8,  str_requirement: nil, stealth_disadvantage: true,  properties: "Padded armor consists of quilted layers of cloth and batting." },
  { name: "Leather",         armor_type: "Light",  armor_class: "11 + Dex mod",              cost: 10,   weight: 10, str_requirement: nil, stealth_disadvantage: false, properties: "The breastplate and shoulder protectors of this armor are made of leather." },
  { name: "Studded Leather", armor_type: "Light",  armor_class: "12 + Dex mod",              cost: 45,   weight: 13, str_requirement: nil, stealth_disadvantage: false, properties: "Made from tough but flexible leather, studded with close-set rivets or spikes." },
  # Medium Armor
  { name: "Hide",            armor_type: "Medium", armor_class: "12 + Dex mod (max 2)",      cost: 10,   weight: 12, str_requirement: nil, stealth_disadvantage: false, properties: "This crude armor consists of thick furs and pelts." },
  { name: "Chain Shirt",     armor_type: "Medium", armor_class: "13 + Dex mod (max 2)",      cost: 50,   weight: 20, str_requirement: nil, stealth_disadvantage: false, properties: "Made of interlocking metal rings, a chain shirt is worn between layers of clothing or leather." },
  { name: "Scale Mail",      armor_type: "Medium", armor_class: "14 + Dex mod (max 2)",      cost: 50,   weight: 45, str_requirement: nil, stealth_disadvantage: true,  properties: "Consists of a coat and leggings (and perhaps a separate skirt) of leather covered with overlapping pieces of metal." },
  { name: "Breastplate",     armor_type: "Medium", armor_class: "14 + Dex mod (max 2)",      cost: 400,  weight: 20, str_requirement: nil, stealth_disadvantage: false, properties: "Consists of a fitted metal chest piece worn with supple leather. Although it leaves the legs and arms relatively unprotected, this armor provides good protection for the wearer's vital organs." },
  { name: "Half Plate",      armor_type: "Medium", armor_class: "15 + Dex mod (max 2)",      cost: 750,  weight: 40, str_requirement: nil, stealth_disadvantage: true,  properties: "Consists of shaped metal plates that cover most of the wearer's body. It does not include leg protection beyond simple greaves that are attached with leather straps." },
  # Heavy Armor
  { name: "Ring Mail",       armor_type: "Heavy",  armor_class: "14",                         cost: 30,   weight: 40, str_requirement: nil, stealth_disadvantage: true,  properties: "This armor is leather armor with heavy rings sewn into it. The rings help reinforce the armor against blows from swords and axes." },
  { name: "Chain Mail",      armor_type: "Heavy",  armor_class: "16",                         cost: 75,   weight: 55, str_requirement: 13,  stealth_disadvantage: true,  properties: "Made of interlocking metal rings, chain mail includes a layer of quilted fabric worn underneath the mail to prevent chafing and to cushion the impact of blows." },
  { name: "Splint",          armor_type: "Heavy",  armor_class: "17",                         cost: 200,  weight: 60, str_requirement: 15,  stealth_disadvantage: true,  properties: "Made of narrow vertical strips of metal riveted to a backing of leather that is worn over cloth padding. Flexible chain mail protects the joints." },
  { name: "Plate",           armor_type: "Heavy",  armor_class: "18",                         cost: 1500, weight: 65, str_requirement: 15,  stealth_disadvantage: true,  properties: "Plate consists of shaped, interlocking metal plates to cover the entire body. A suit of plate includes gauntlets, heavy leather boots, a visored helmet, and thick layers of padding underneath the armor." },
  # Shield
  { name: "Shield",          armor_type: "Shield", armor_class: "+2",                         cost: 10,   weight: 6,  str_requirement: nil, stealth_disadvantage: false, properties: "A shield is made from wood or metal and is carried in one hand. Wielding a shield increases your Armor Class by 2. You can benefit from only one shield at a time." }
])
puts "Armors created: #{Armor.count}"
