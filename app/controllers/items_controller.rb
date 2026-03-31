class ItemsController < ApplicationController
  before_action :set_own_item, only: [:edit, :update, :destroy, :remove_character, :update_image]

  def index
    base = if current_user&.admin?
             Item
           elsif user_signed_in?
             current_user.items.any? ? current_user.items : Item.limit(1)
           else
             Item
           end

    items = base.includes(:category, :rarity, :effects).with_attached_image
                .search_by_name(params[:q])
                .by_category(params[:category_id])
                .by_rarity(params[:rarity_id])
                .by_attunement(params[:attunement])
                .sorted(params[:sort], params[:dir])

    @pagy, @items = pagy(items, limit: parse_per_page)
    @categories = Category.order(:name)
    @rarities = Rarity.order(:name)
    @is_sample = user_signed_in? && !current_user.admin? && current_user.items.empty?
  end

  def show
    scope = current_user.admin? ? Item : current_user.items
    @item = scope.includes(:category, :rarity, :effects).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to items_path, alert: t("shared.not_found")
  end

  def new
    @item = Item.new
    @weapons = Weapon.all
    @armors = Armor.order(:armor_type, :name)
    @categories = Category.with_attached_image.all
    @rarities = Rarity.all
    @effects = Effect.all
  end

  def get_item
    scope = current_user.admin? ? Item : current_user.items
    item = scope.find_by(id: params[:id])
    return render json: { status: "error", message: t("shared.not_found") }, status: :not_found unless item

    respond_to do |format|
      format.json { render json: { status: "success", item: item.as_json.merge(origin: item.origin, lore: item.lore, weapon_name: item.weapon_name), effects: item.effects.map { |e| { id: e.id, name: e.translated_name, effect_type: e.effect_type, power_level: e.power_level, description: e.translated_description } } } }
    end
  end

  def update_item
    scope = current_user.admin? ? Item : current_user.items
    item = scope.find_by(id: params[:id])
    return render json: { status: "error", message: t("shared.not_found") }, status: :not_found unless item

    category = Category.find_by(id: params[:category])
    rarity = Rarity.find_by(name: params[:rarity])
    return render json: { status: "error", message: t("shared.invalid_params") }, status: :unprocessable_entity unless category && rarity

    effect_ids = params[:effects] || []
    effects = Effect.where(id: effect_ids)
    weapon = params[:weapon].presence || params[:armor].presence
    power = params[:power].to_i.clamp(0, 10)

    description = if params[:description_locked] == "true" && params[:description].present?
                    params[:description]
                  else
                    ItemEngine.generate_description(rarity.name, effects, category, weapon, lore: lore_param)
                  end

    item.update!(
      name:               params[:name],
      category:           category,
      rarity:             rarity,
      description:        description,
      item_type:          category.name,
      power:              power,
      weight:             rand(category.min_weight..category.max_weight),
      price:              calculate_price(rarity),
      requires_attunement: power > 2,
      origin:             origin_param,
      lore:               lore_param,
      weapon_name:        weapon.presence,
    )
    item.effects = effects

    respond_to do |format|
      format.json { render json: { status: "success", data: "Item updated! #{item.name}" } }
    end
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  def create_item
    category = Category.find_by(id: params[:category])
    rarity = Rarity.find_by(name: params[:rarity])
    return render json: { status: "error", message: t("shared.invalid_params") }, status: :unprocessable_entity unless category && rarity

    effect_ids = params[:effects] || []
    effects = Effect.where(id: effect_ids)
    weapon = params[:weapon].presence || params[:armor].presence
    power = params[:power].to_i.clamp(0, 10)

    description = if params[:description_locked] == "true" && params[:description].present?
                    params[:description]
                  else
                    ItemEngine.generate_description(rarity.name, effects, category, weapon, lore: lore_param)
                  end

    item = Item.create!(
      name:               params[:name],
      category:           category,
      rarity:             rarity,
      description:        description,
      item_type:          category.name,
      power:              power,
      weight:             rand(category.min_weight..category.max_weight),
      price:              calculate_price(rarity),
      requires_attunement: power > 2,
      origin:             origin_param,
      lore:               lore_param,
      weapon_name:        weapon.presence,
      user:               current_user,
    )
    item.effects = effects

    respond_to do |format|
      format.json { render json: { status: "success", item_id: item.id, data: "Item created! #{item.name}" } }
    end
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user

    if @item.save
      redirect_to @item, notice: t("items.created")
    else
      render :new
    end
  end

  def edit
    @weapons = Weapon.all
    @armors = Armor.order(:armor_type, :name)
    @categories = Category.with_attached_image.all
    @rarities = Rarity.all
    @effects = Effect.all
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: t("items.updated")
    else
      render :edit
    end
  end

  def destroy
    @item.item_effects.destroy_all
    @item.destroy
    redirect_to items_path, notice: t("items.deleted")
  end

  def update_image
    if params.dig(:item, :image).present?
      @item.image.attach(params[:item][:image])
    elsif params[:remove_image] == "1" && @item.image.attached?
      @item.image.purge
    end
    redirect_to edit_item_path(@item), notice: t("items.image_updated")
  end

  def remove_character
    character = @item.character
    @item.update!(character: nil)
    redirect_back fallback_location: (character ? character_path(character) : items_path)
  end

  # ── Create Random Items ──
  def create_random
    @categories = Category.all
    @power_levels = (1..10).to_a
    @rarities = Rarity.all

    return if request.get?

    fully_random = params[:fully_random] == "true"
    power = fully_random ? rand(1..10) : (params[:power_level] || rand(1..10)).to_i
    power = power.clamp(1, 10)
    category_id = fully_random ? Category.pluck(:id).sample : params[:category_id]

    item = random_create(power, category_id)

    respond_to do |format|
      format.json { render json: { status: "success", item: item_json(item) } }
      format.html { redirect_to create_random_items_path }
    end
  rescue => e
    respond_to do |format|
      format.json { render json: { status: "error", message: e.message }, status: :unprocessable_entity }
      format.html { redirect_to create_random_items_path, alert: e.message }
    end
  end

  def random_create(power, category_id)
    category = Category.find(category_id.to_i)
    rarity_name = get_rarity_name(power)
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

    if category.name == "Weapons"
      effect = find_attack_effect(available_power, category, "Attack Bonus")
      if effect
        item.effects << effect
        available_power -= effect.power_level
        selected_types << effect.effect_type
      end

      if available_power > 0
        effect = find_attack_effect(available_power, category, "Attack Damage")
        if effect
          item.effects << effect
          available_power -= effect.power_level
          selected_types << effect.effect_type
        end
      end
    elsif category.name == "Armor" || category.name == "Shields"
      effect = find_attack_effect(available_power, category, "Defense")
      if effect
        item.effects << effect
        available_power -= effect.power_level
        selected_types << effect.effect_type
      end

      if available_power > 0
        effect = find_attack_effect(available_power, category, "Resistance")
        if effect
          item.effects << effect
          available_power -= effect.power_level
          selected_types << effect.effect_type
        end
      end
    end

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

    actual_power = item.effects.sum(:power_level)
    rarity_name = get_rarity_name(actual_power)
    rarity = Rarity.find_by(name: rarity_name)

    item.power = actual_power
    item.rarity = rarity
    item.price = rand(rarity.min_price..rarity.max_price)
    item.requires_attunement = actual_power > 2
    item.name = ItemEngine.generate_name(rarity_name, item.effects, category, nil, lore: lore_param)
    item.description = ItemEngine.generate_description(rarity_name, item.effects, category, nil, lore: lore_param)
    item.save!
    item
  end

  def get_item_description
    category = Category.find_by(id: params[:category])
    rarity = Rarity.find_by(name: params[:rarity])
    return render json: { status: "error", message: t("shared.invalid_params") }, status: :unprocessable_entity unless category && rarity

    effect_ids = params[:effects] || []
    effects = Effect.where(id: effect_ids)
    weapon = params[:weapon].presence || params[:armor].presence

    description = ItemEngine.generate_description(rarity.name, effects, category, weapon, lore: lore_param)
    render json: { status: "success", data: description }
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  def get_item_name
    category = Category.find_by(id: params[:category])
    return render json: { status: "error", message: t("shared.invalid_params") }, status: :unprocessable_entity unless category

    effect_ids = params[:effects] || []
    effects = Effect.where(id: effect_ids)
    weapon = params[:weapon].presence || params[:armor].presence
    power = (params[:power] || 0).to_i.clamp(0, 10)
    rarity_name = get_rarity_name(power)

    name = ItemEngine.generate_name(rarity_name, effects, category, weapon, lore: lore_param, origin: origin_param)

    respond_to do |format|
      format.json { render json: { status: "success", data: name } }
    end
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  # ── Wizard: recommend effects based on current selection ──
  def recommend_effects
    category = Category.find_by(id: params[:category_id])
    return render json: { status: "error", message: t("shared.invalid_params") }, status: :unprocessable_entity unless category

    selected_types = params[:selected_types] || []
    available_power = (params[:available_power] || 0).to_i.clamp(0, 10)

    recommendations = ItemEngine.recommend_effects(category, selected_types, available_power)
    synergies = ItemEngine.synergies_for(selected_types)

    respond_to do |format|
      format.json {
        render json: {
          status: "success",
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
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  # ── Wizard page ──
  def wizard
    @categories = Category.all
    @weapons = Weapon.all
    @armors = Armor.order(:armor_type, :name)
    @rarities = Rarity.all
  end

  private

    def set_own_item
      scope = current_user.admin? ? Item : current_user.items
      @item = scope.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to items_path, alert: t("shared.not_authorized")
    end

    def find_attack_effect(power, category, effect_type)
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

    def get_rarity_name(power)
      case power
      when 0..1 then "Common"
      when 2..3 then "Uncommon"
      when 4..5 then "Rare"
      when 6..7 then "Very Rare"
      when 8..9 then "Legendary"
      when 10 then "Ancestral"
      end
    end

    def calculate_price(rarity)
      price = rand(rarity.min_price..rarity.max_price).round(-1)
      price_length = price.to_s.length
      price.round(-(price_length - 2))
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

    def lore_param
      %w[faerun middle_earth].include?(params[:lore]) ? params[:lore] : "faerun"
    end

    def origin_param
      Item::ORIGINS.include?(params[:origin]) ? params[:origin] : "Desconocido"
    end

    def item_params
      params.require(:item).permit(:name, :description, :item_type, :rarity, :category_id, :price, :weight, :category, :power, effects: [])
    end
end
