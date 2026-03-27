class EffectsController < ApplicationController
  before_action :set_effect, only: [:show, :edit, :update, :destroy]

  def index
    effects = Effect.includes(:categories)
                    .search_by_name(params[:q])
                    .by_effect_type(params[:effect_type])
                    .by_power_level(params[:power_level])
                    .sorted(params[:sort], params[:dir])

    per_page = [params[:per_page].to_i, 10].max rescue 20
    per_page = [per_page, 100].min
    @pagy, @effects = pagy(effects, limit: per_page)
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
      redirect_to effects_path, notice: 'Effect was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @effect.update(effect_params)
      redirect_to effect_path(@effect), notice: 'Effect was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @effect.destroy
    redirect_to effects_path, notice: 'Effect was successfully deleted.'
  end

  def get_effects_by_category
    category_name = params[:category]

    effects = Effect.joins(:categories).where(categories: { name: category_name })

    respond_to do |format|
      format.json { render json: { status: 'success', data: effects }}
    end
  end

  private

  def set_effect
    @effect = Effect.find(params[:id])
  end

  def effect_params
    params.require(:effect).permit(:name, :description, :power_level)
  end
end
