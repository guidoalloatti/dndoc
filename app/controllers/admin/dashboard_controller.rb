module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        total_users:      User.count,
        admin_users:      User.where(admin: true).count,
        total_items:      Item.count,
        total_effects:    Effect.count,
        total_categories: Category.count,
        total_rarities:   Rarity.count,
        total_weapons:    Weapon.count,
        total_parties:    Party.count,
        total_characters: Character.count,
        total_classes:    CharacterClass.count,
        total_lore:       LoreEntry.count,
        items_today:      Item.where("created_at >= ?", Time.current.beginning_of_day).count,
        users_today:      User.where("created_at >= ?", Time.current.beginning_of_day).count
      }

      @recent_users  = User.order(created_at: :desc).limit(6)
      @recent_items  = Item.includes(:user, :category, :rarity).order(created_at: :desc).limit(8)
      @top_creators  = User.left_joins(:items)
                           .select("users.*, COUNT(items.id) as items_count")
                           .group("users.id")
                           .order("items_count DESC")
                           .limit(5)
      @items_by_rarity = Rarity.left_joins(:items)
                               .select("rarities.name, COUNT(items.id) as items_count")
                               .group("rarities.id, rarities.name")
                               .order("rarities.min_power ASC")
      @effects_by_type = Effect.group(:effect_type).count.sort_by { |_, v| -v }.first(8)
      @recent_parties  = Party.includes(:user, :characters).order(created_at: :desc).limit(5)
    end
  end
end
