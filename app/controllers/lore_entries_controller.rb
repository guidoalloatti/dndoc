class LoreEntriesController < ApplicationController
  before_action :require_admin!
  before_action :set_lore_entry, only: [:edit, :update, :destroy]

  CATEGORY_GROUPS = {
    "generation"  => %w[prefix suffix simple_suffix category_title],
    "world"       => %w[smith wielder place event deity organization material age],
    "description" => %w[origin historical_anecdote effect_transition dramatic_closing],
    "effects"     => %w[effect_description effect_flavor],
    "character"   => %w[personality_trait curse prophecy],
  }.freeze

  def index
    @lore_type = params[:lore_type].presence
    @category  = params[:category].presence
    @q         = params[:q].presence

    if @lore_type.present? && @category.present?
      # ── Detail mode ──
      entries = LoreEntry.where(lore_type: @lore_type, category: @category)
      entries = entries.where("value ILIKE ?", "%#{@q}%") if @q.present?
      entries = entries.order(:key, :id)
      @pagy, @lore_entries = pagy(entries, limit: parse_per_page(100))
      @keyed = LoreEntry::KEYED_CATEGORIES.include?(@category)
      @mode  = :detail
    else
      # ── Overview mode ──
      counts_raw = LoreEntry.group(:lore_type, :category).count
      @counts = counts_raw.each_with_object({}) do |((lt, cat), n), h|
        h[lt] ||= {}
        h[lt][cat] = n
      end
      @total  = LoreEntry.count
      @mode   = :overview
    end
  end

  def new
    @lore_entry = LoreEntry.new(
      lore_type: params[:lore_type] || "faerun",
      category:  params[:category],
      key:       params[:key]
    )
  end

  def create
    @lore_entry = LoreEntry.new(lore_entry_params)
    if @lore_entry.save
      LoreEntry.clear_cache!
      redirect_to lore_entries_path(lore_type: @lore_entry.lore_type, category: @lore_entry.category),
                  notice: t("lore_entries.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @lore_entry.update(lore_entry_params)
      LoreEntry.clear_cache!
      redirect_to lore_entries_path(lore_type: @lore_entry.lore_type, category: @lore_entry.category),
                  notice: t("lore_entries.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    lt  = @lore_entry.lore_type
    cat = @lore_entry.category
    @lore_entry.destroy
    LoreEntry.clear_cache!
    redirect_to lore_entries_path(lore_type: lt, category: cat),
                notice: t("lore_entries.deleted")
  end

  private

  def set_lore_entry
    @lore_entry = LoreEntry.find(params[:id])
  end

  def lore_entry_params
    params.require(:lore_entry).permit(:lore_type, :category, :key, :value)
  end
end
