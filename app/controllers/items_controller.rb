class ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
    @weapons = Weapon.all
    @categories = Category.all
    @rarities = Rarity.all
    @effects = Effect.all
  end

  def create_item
    item_name = params[:name]
    rarity_name = params[:rarity]
    rarity = Rarity.find_by(name: rarity_name)
    category_id = params[:category] || ""
    weapon = params[:weapon] || ""
    power = params[:power].to_i || 0
    effect_ids = params[:effects] || []

    category = Category.find(category_id)
    effects = Effect.find(effect_ids)

    item = Item.create!(
      name:               item_name,
      category:           category,
      rarity:             rarity,
      description:        "A very interesting item with mysterious properties.",
      item_type:          "item type",
      power:              power,
      weight:             rand(category.min_weight..category.max_weight),
      price:              getPrice(rarity),
      requires_attunement: power > 2,
    )

    item.effects = effects
    item.save!
    
    respond_to do |format|
      format.json {
        render json: { 
          status: 'success',
          data: "Item created! #{item_name} | Power: #{power}"
        }
      }
    end
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def edit

    @item = Item.find(params[:id])

    @weapons = Weapon.all
    @categories = Category.all
    @rarities = Rarity.all
    @effects = Effect.all

    # @selectedCategory = 
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.item_effects.destroy_all    
    @item.destroy
    redirect_to items_path, notice: 'Item was successfully removed.'
  end

  def getPrice(rarity)
    price = rand(rarity.min_price..rarity.max_price).round(-1)
    price_length = price.to_s.length
    rounded_price = price.round(-(price_length - 2))
  end

  # Create Random Items
  def create_random
    @categories = Category.all
    @power_levels = (1..10).to_a

    power = params[:power_level]
    category_id = params[:category_id]
    commit = params[:commit]

    if commit == "Generate Fully Random Item"
      random_create(rand(1..10), Category.all.sample.id)
    end
    return unless power.present? && category_id.present? && commit.present?

    if commit == "Generate Item"
      random_create(power.to_i, category_id)
    end
  end

  def random_create(power, category_id)
    category = Category.find(category_id.to_i)
    rarity_name = getRarity(power)
    rarity = Rarity.find_by(name: rarity_name)
    
    item = Item.create!(
      name:               "temp name",
      category:           category,
      rarity:             rarity,
      description:        "A very interesting item with mysterious properties.",
      item_type:          "item type",
      power:              power,
      weight:             rand(category.min_weight..category.max_weight),
      price:              rand(rarity.min_price..rarity.max_price),
      requires_attunement: power > 2,
    )

    available_power = item.power

    if category.name == "Weapons"
      effect = addAttackEffect(available_power, category, "Attack Bonus")
      item.effects << effect
      available_power -= effect.power_level

      if available_power > 0
        effect = addAttackEffect(available_power, category, "Attack Damage")
        item.effects << effect
        available_power -= effect.power_level
      end
    end

    while available_power > 0 do
      effect_types = []
      item.effects.each do |effect|
        effect_types << effect.effect_type
      end
   
      effect = getEffect(available_power, category, effect_types)
      break if effect.nil?

      item.effects << effect if effect.present?
      available_power -= effect.power_level
    end

    item.name = item_name = getItemName(rarity_name, item.effects, category, nil)

    item.save!
  end

  def get_item_name
    category_id = params[:category] || ""
    weapon = params[:weapon] || ""
    power = params[:power] || 0
    effect_ids = params[:effects] || []

    rarity_name = getRarity(power.to_i)
    category = Category.find(category_id)
    effects = Effect.find(effect_ids)
    
    name = getItemName(rarity_name, effects, category, weapon)

    respond_to do |format|
      format.json { render json: { status: 'success', data: name }}
    end

  end

  private
    def addAttackEffect(power, category, effect_type)
      min_power, max_power =  case power
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

    def getRarity(power)
      rarity = case power
                when 0..1 then "Common"
                when 2..3 then "Uncommon"
                when 4..5 then "Rare"
                when 6..7 then "Very Rare"
                when 8..9 then "Legendary"
                when 10 then "Ancestral"
               end
      rarity
    end

    def getCategory
    end

    def getEffect(power, category, effect_types)
      Effect.joins(:categories)
                .where(categories: { id: category.id })
                .where.not(effect_type: effect_types)
                .where("power_level <= ?", power)
                .sample
    end

    def getWeaponType
      Weapon.all.sample.name
    end

    def getRarityName(rarity_name)
      rarity_options = {
          "Common" => ["Simple", "Regular", "Mundane", "Acceptable", "Mediocre", "Consistent", "Ordinary", "Usual", "Normal", "Plain", "Routine", "Standard", "Typical", "Familiar", "Generic"],
          "Uncommon" => ["Good", "Improved", "Promising", "Advantageous", "Competent", "Helpful", "Respected", "Remarkable", "Noble", "Uncommon", "Distinct", "Noteworthy", "Notable", "Beneficial", "Unique"],
          "Rare" => ["Powerful", "Great", "Prestigious", "Outstanding", "Exceptional", "Admirable", "Premium", "Notable", "Superior", "Renowned", "Exclusive", "Valuable", "Esteemed", "Rare", "Select"],
          "Very Rare" => ["Amazing", "Spectacular", "Omniscient", "Chivalrous", "Marvelous", "Iconic", "Celestial", "Exquisite", "Eminent", "Admirable", "Astonishing", "Incredible", "Phenomenal", "Mystical", "Unrivaled"],
          "Legendary" => ["Legendary", "Overpowered", "Magnificent", "Heroic", "Immortalized", "Fabled", "Exalted", "Arcane", "Timeless", "Supreme", "Unmatched", "Divine", "Unparalleled", "Sovereign", "Glorious", "Imperial"],
          "Ancestral" => ["Ancestral", "Mythic", "Epic", "Primordial", "Primal", "Transcendent", "Divine", "Eternal", "Celestial", "Infinite", "Ancient", "Cosmic", "Primeval", "Originating", "Boundless"]
        }

      rarity_options[rarity_name]&.sample
    end

    def getCategoryName(category)
      category.name == "Weapons" ? getWeaponType : category.name
    end

    def getItemName(rarity, effects, category, weapon)
      rarity_name = getRarityName(rarity)
      
      category_name = (category.name == "Weapons" && weapon.present?) ? weapon : getCategoryName(category)

      effect_types = effects.pluck(:effect_type).sample
      # effect_categories_names = effects.pluck(:name).sample # join(", ")

      name_parts = []
      name_parts << "#{rarity_name}"
      name_parts << "#{category_name}"
      name_parts << "#{effect_types.present? ? "of #{effect_types}" : ''}" 
      # name_parts << "with #{effect_categories_names}" if effect_categories_names.present?

      name_parts.join(" ")
    end

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :description, :item_type, :rarity, :category_id, :price, :weight, :category, :power, effects: [])
    end
end
