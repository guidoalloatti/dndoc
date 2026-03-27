class MainController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @stats = {
      items: Item.count,
      effects: Effect.count,
      categories: Category.count,
      weapons: Weapon.count,
      rarities: Rarity.count,
    }

    if user_signed_in?
      @user_items_count = current_user.items.count
      @recent_items = current_user.items.includes(:category, :rarity, :effects)
                                       .order(created_at: :desc).limit(6)
    end

    # Showcase data for landing page
    @rarities = Rarity.order(:min_power)
    @sample_item = Item.includes(:category, :rarity, :effects)
                       .where.not(description: [nil, ""])
                       .order(power: :desc).first
  end
end
