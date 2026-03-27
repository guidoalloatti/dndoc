class ItemsController < ApplicationController

  def index
    base = if user_signed_in?
             current_user.items.any? ? current_user.items : Item.limit(1)
           else
             Item
           end

    items = base.includes(:category, :rarity, :effects)
                .search_by_name(params[:q])
                .by_category(params[:category_id])
                .by_rarity(params[:rarity_id])
                .by_attunement(params[:attunement])
                .sorted(params[:sort], params[:dir])

    per_page = [params[:per_page].to_i, 10].max rescue 20
    per_page = [per_page, 100].min
    @pagy, @items = pagy(items, limit: per_page)
    @categories = Category.order(:name)
    @rarities = Rarity.order(:name)
    @is_sample = user_signed_in? && current_user.items.empty?
  end

  def show
    @item = Item.includes(:category, :rarity, :effects).find(params[:id])
  end

  def new
    @item = Item.new
    @weapons = Weapon.all
    @categories = Category.all
    @rarities = Rarity.all
    @effects = Effect.all
  end

  def get_item
    item = Item.find_by(id: params[:id])
    effects = item.effects

    respond_to do |format|
      format.json { render json: { status: 'success', item: item, effects: effects }}
    end
  end

  def update_item
    id = params[:id]
    item_name = params[:name]
    rarity_name = params[:rarity]
    rarity = Rarity.find_by(name: rarity_name)
    category_id = params[:category] || ""
    weapon = params[:weapon] || ""
    power = params[:power].to_i || 0
    effect_ids = params[:effects] || []

    category = Category.find(category_id)
    effects = Effect.find(effect_ids)

    item = Item.find(id)
    item.update!(
      name:               item_name,
      category:           category,
      rarity:             rarity,
      description:        ItemEngine.generate_description(rarity_name, effects, category, weapon.presence),
      item_type:          category.name,
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
          data: "Item updated! #{item_name} | Power: #{power} | Id: #{id}"
        }
      }
    end
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
      description:        ItemEngine.generate_description(rarity_name, effects, category, weapon.presence),
      item_type:          category.name,
      power:              power,
      weight:             rand(category.min_weight..category.max_weight),
      price:              getPrice(rarity),
      requires_attunement: power > 2,
      user:               current_user,
    )

    item.effects = effects
    item.save!

    respond_to do |format|
      format.json {
        render json: {
          status: 'success',
          item_id: item.id,
          data: "Item created! #{item_name} | Power: #{power}"
        }
      }
    end
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user

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
    price.round(-(price_length - 2))
  end

  # ── Create Random Items ──
  def create_random
    @categories = Category.all
    @power_levels = (1..10).to_a
    @rarities = Rarity.all

    return if request.get?

    fully_random = params[:fully_random] == "true"
    power = fully_random ? rand(1..10) : (params[:power_level] || rand(1..10)).to_i
    category_id = fully_random ? Category.all.sample.id : params[:category_id]

    item = random_create(power, category_id)

    respond_to do |format|
      format.json {
        render json: {
          status: "success",
          item: item_json(item)
        }
      }
      format.html { redirect_to create_random_items_path }
    end
  end

  def random_create(power, category_id)
    category = Category.find(category_id.to_i)
    rarity_name = getRarity(power)
    rarity = Rarity.find_by(name: rarity_name)

    item = Item.create!(
      name:                "temp name",
      category:            category,
      rarity:              rarity,
      description:         "",
      item_type:           category.name,
      power:               power,
      weight:              rand(category.min_weight..category.max_weight),
      price:               rand(rarity.min_price..rarity.max_price),
      requires_attunement: power > 2,
      user:                current_user,
    )

    available_power = item.power
    selected_types = []

    # Weapons get attack effects first
    if category.name == "Weapons"
      effect = addAttackEffect(available_power, category, "Attack Bonus")
      if effect
        item.effects << effect
        available_power -= effect.power_level
        selected_types << effect.effect_type
      end

      if available_power > 0
        effect = addAttackEffect(available_power, category, "Attack Damage")
        if effect
          item.effects << effect
          available_power -= effect.power_level
          selected_types << effect.effect_type
        end
      end
    end

    # Fill remaining power using synergy-aware recommendations
    attempts = 0
    while available_power > 0 && attempts < 20
      attempts += 1
      recommendations = ItemEngine.recommend_effects(category, selected_types, available_power)
      best = recommendations.first
      break unless best

      effect = best[:effect]
      item.effects << effect
      available_power -= effect.power_level
      selected_types << effect.effect_type
    end

    item.name = ItemEngine.generate_name(rarity_name, item.effects, category, nil)
    item.description = ItemEngine.generate_description(rarity_name, item.effects, category)
    item.save!
    item
  end

  def get_item_name
    category_id = params[:category] || ""
    weapon = params[:weapon] || ""
    power = params[:power] || 0
    effect_ids = params[:effects] || []

    rarity_name = getRarity(power.to_i)
    category = Category.find(category_id)
    effects = Effect.find(effect_ids)

    name = ItemEngine.generate_name(rarity_name, effects, category, weapon.presence)

    respond_to do |format|
      format.json { render json: { status: 'success', data: name }}
    end
  end

  # ── Wizard: recommend effects based on current selection ──
  def recommend_effects
    category = Category.find(params[:category_id])
    selected_types = params[:selected_types] || []
    available_power = (params[:available_power] || 0).to_i

    recommendations = ItemEngine.recommend_effects(category, selected_types, available_power)
    synergies = ItemEngine.synergies_for(selected_types)

    respond_to do |format|
      format.json {
        render json: {
          status: 'success',
          recommendations: recommendations.first(12).map { |r|
            {
              id: r[:effect].id,
              name: r[:effect].name,
              effect_type: r[:effect].effect_type,
              power_level: r[:effect].power_level,
              description: r[:effect].description,
              synergy: r[:synergy],
              score: r[:score]
            }
          },
          synergy_types: synergies,
          conflict_types: selected_types.flat_map { |t| ItemEngine::CONFLICTS[t] || [] }.uniq
        }
      }
    end
  end

  # ── Wizard page ──
  def wizard
    @categories = Category.all
    @weapons = Weapon.all
    @rarities = Rarity.all
  end

  private

    def addAttackEffect(power, category, effect_type)
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

    def getRarity(power)
      case power
      when 0..1 then "Common"
      when 2..3 then "Uncommon"
      when 4..5 then "Rare"
      when 6..7 then "Very Rare"
      when 8..9 then "Legendary"
      when 10 then "Ancestral"
      end
    end

    def getEffect(power, category, effect_types)
      Effect.joins(:categories)
            .where(categories: { id: category.id })
            .where.not(effect_type: effect_types)
            .where("power_level <= ?", power)
            .sample
    end

    def item_json(item)
      {
        id: item.id,
        name: item.name,
        description: item.description,
        power: item.power,
        weight: item.weight,
        price: item.price,
        requires_attunement: item.requires_attunement,
        category: item.category.name,
        rarity: item.rarity.name,
        effects: item.effects.map { |e|
          { name: e.name, effect_type: e.effect_type, power_level: e.power_level, description: e.description }
        }
      }
    end

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :description, :item_type, :rarity, :category_id, :price, :weight, :category, :power, effects: [])
    end
end
