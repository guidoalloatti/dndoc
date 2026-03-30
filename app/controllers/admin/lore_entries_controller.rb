module Admin
  class LoreEntriesController < BaseController
    before_action :set_lore_entry, only: [:edit, :update, :destroy]

    def index
      @lore_type = params[:lore_type]
      @category  = params[:category]
      @q         = params[:q]

      entries = LoreEntry.all
      entries = entries.where(lore_type: @lore_type) if @lore_type.present?
      entries = entries.where(category: @category)   if @category.present?
      entries = entries.where("value ILIKE ?", "%#{@q}%") if @q.present?
      entries = entries.order(:lore_type, :category, :key, :value)

      @pagy, @lore_entries = pagy(entries, limit: parse_per_page(50))
      @total_count = LoreEntry.count
    end

    def new
      @lore_entry = LoreEntry.new(
        lore_type: params[:lore_type],
        category:  params[:category],
        key:       params[:key]
      )
    end

    def create
      @lore_entry = LoreEntry.new(lore_entry_params)
      if @lore_entry.save
        LoreEntry.clear_cache!
        redirect_to admin_lore_entries_path(lore_type: @lore_entry.lore_type, category: @lore_entry.category),
                    notice: t('admin.lore_entries.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @lore_entry.update(lore_entry_params)
        LoreEntry.clear_cache!
        redirect_to admin_lore_entries_path(lore_type: @lore_entry.lore_type, category: @lore_entry.category),
                    notice: t('admin.lore_entries.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      lt  = @lore_entry.lore_type
      cat = @lore_entry.category
      @lore_entry.destroy
      LoreEntry.clear_cache!
      redirect_to admin_lore_entries_path(lore_type: lt, category: cat),
                  notice: t('admin.lore_entries.deleted')
    end

    private

    def set_lore_entry
      @lore_entry = LoreEntry.find(params[:id])
    end

    def lore_entry_params
      params.require(:lore_entry).permit(:lore_type, :category, :key, :value)
    end
  end
end
