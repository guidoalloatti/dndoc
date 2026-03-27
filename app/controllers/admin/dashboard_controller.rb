module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        total_users: User.count,
        admin_users: User.where(admin: true).count,
        total_items: Item.count,
        total_effects: Effect.count,
        total_categories: Category.count,
        total_rarities: Rarity.count,
        total_weapons: Weapon.count
      }

      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_items = Item.includes(:user, :category, :rarity)
                          .order(created_at: :desc).limit(10)
      @top_creators = User.left_joins(:items)
                          .select("users.*, COUNT(items.id) as items_count")
                          .group("users.id")
                          .order("items_count DESC")
                          .limit(5)
      @items_by_rarity = Rarity.left_joins(:items)
                               .select("rarities.name, COUNT(items.id) as items_count")
                               .group("rarities.id, rarities.name")
                               .order("rarities.min_power ASC")
    end
  end
end
