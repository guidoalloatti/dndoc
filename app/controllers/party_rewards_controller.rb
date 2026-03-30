class PartyRewardsController < ApplicationController
  def new
    @character_classes = CharacterClass.order(:name)
    @parties = current_user.parties.includes(:characters).order(:name)
    @preload_party_id = params[:party_id]
  end

  def generate
    members = params[:party_members] || []
    items_per_member = (params[:items_per_member] || 1).to_i.clamp(1, 5)

    party_data = members.map do |m|
      {
        name: m[:name],
        character_class_id: m[:character_class_id],
        race: m[:race],
        level: m[:level],
        reward_level: m[:reward_level],
        character_id: m[:character_id].presence,
      }
    end

    results = PartyRewardEngine.generate_party_rewards(party_data, items_per_member, lore: lore_param)

    render json: { status: "success", results: results }
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  def regenerate_item
    char_class = CharacterClass.find(params[:character_class_id])
    level = params[:level].to_i.clamp(1, 20)
    reward_level = params[:reward_level]
    race = params[:race].presence

    item = PartyRewardEngine.build_reward_item(char_class, level, reward_level, race, lore: lore_param)

    render json: { status: "success", item: item }
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  def save_all
    items_data = params[:items] || []
    saved_items = []

    ActiveRecord::Base.transaction do
      items_data.each do |item_data|
        category = Category.find(item_data[:category_id])
        rarity = Rarity.find(item_data[:rarity_id])
        effect_ids = item_data[:effect_ids] || []

        character = Character.joins(:party).find_by(id: item_data[:character_id], parties: { user_id: current_user.id }) if item_data[:character_id].present?

        item = Item.create!(
          name: item_data[:name],
          description: item_data[:description],
          item_type: item_data[:item_type],
          power: item_data[:power].to_i,
          weight: item_data[:weight],
          price: item_data[:price].to_i,
          requires_attunement: item_data[:requires_attunement] == true || item_data[:requires_attunement] == "true",
          category: category,
          rarity: rarity,
          user: current_user,
          character: character,
        )

        effects = Effect.where(id: effect_ids)
        item.effects = effects
        saved_items << item
      end
    end

    render json: { status: "success", count: saved_items.size, message: t("party_rewards.saved") }
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  private

  def lore_param
    %w[faerun middle_earth].include?(params[:lore]) ? params[:lore] : "faerun"
  end
end
