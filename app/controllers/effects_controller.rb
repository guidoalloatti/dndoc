class EffectsController < ApplicationController
  before_action :set_effect, only: [:show, :edit, :update, :destroy, :detail_panel]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    effects = Effect.includes(:categories)
                    .search_by_name(params[:q])
                    .by_effect_type(params[:effect_type])
                    .by_power_level(params[:power_level])
                    .sorted(params[:sort], params[:dir])

    @pagy, @effects = pagy(effects, limit: parse_per_page)
    @effect_types = Effect.distinct.order(:effect_type).pluck(:effect_type)
    @power_levels = Effect.distinct.order(:power_level).pluck(:power_level)
  end

  def show
  end

  def new
    @effect = Effect.new
  end

  def create
    @effect = Effect.new(effect_params)
    if @effect.save
      redirect_to effects_path, notice: t("effects.created")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @effect.update(effect_params)
      redirect_to effect_path(@effect), notice: t("effects.updated")
    else
      render :edit
    end
  end

  def destroy
    @effect.destroy
    redirect_to effects_path, notice: t("effects.deleted")
  end

  def detail_panel
    color = helpers.effect_type_color(@effect.effect_type)
    icon = helpers.effect_type_icon(@effect.effect_type)
    render partial: 'detail_inline', locals: { effect: @effect, color: color, icon: icon }, layout: false
  end

  def get_effects_by_category
    category_name = params[:category]
    effects = Effect.joins(:categories).where(categories: { name: category_name })

    respond_to do |format|
      format.json do
        render json: {
          status: "success",
          data: effects.map { |e| { id: e.id, name: e.translated_name, effect_type: e.effect_type, power_level: e.power_level, description: e.translated_description } }
        }
      end
    end
  end

  private

  def set_effect
    @effect = Effect.includes(:categories, items: [:category, :rarity]).find(params[:id])
  end

  def effect_params
    params.require(:effect).permit(:name, :description, :power_level, :effect_type, :name_es, :description_es)
  end
end
