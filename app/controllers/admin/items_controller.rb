module Admin
  class ItemsController < BaseController
    before_action :set_item, only: [:show, :destroy]

    def index
      @q               = params[:q]
      @category_filter = params[:category_id]
      @rarity_filter   = params[:rarity_id]

      items = Item.includes(:user, :category, :rarity, :effects)
      items = items.where("items.name ILIKE ?", "%#{@q}%") if @q.present?
      items = items.where(category_id: @category_filter) if @category_filter.present?
      items = items.where(rarity_id: @rarity_filter)     if @rarity_filter.present?
      items = items.order(created_at: :desc)

      @pagy, @items = pagy(items, limit: parse_per_page(50))
      @categories   = Category.order(:name)
      @rarities     = Rarity.order(:min_power)
    end

    def show; end

    def destroy
      @item.destroy
      redirect_to admin_items_path, notice: t('admin.items.deleted')
    end

    private

    def set_item
      @item = Item.includes(:user, :category, :rarity, effects: []).find(params[:id])
    end
  end
end
