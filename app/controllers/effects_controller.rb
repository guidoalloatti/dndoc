class EffectsController < ApplicationController
  before_action :set_effect, only: [:show, :edit, :update, :destroy]

  def index
    @effects = Effect.all.sort_by { |e| e.name }
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
