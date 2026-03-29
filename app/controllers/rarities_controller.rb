class RaritiesController < ApplicationController
  before_action :set_rarity, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    rarities = Rarity.includes(:items)
                     .search_by_name(params[:q])
                     .sorted(params[:sort], params[:dir])

    @pagy, @rarities = pagy(rarities, limit: parse_per_page)
  end

  def new
    @rarity = Rarity.new
  end

  def create
    @rarity = Rarity.new(rarity_params)
    if @rarity.save
      redirect_to rarities_path, notice: t("rarities.created")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @rarity.update(rarity_params)
      redirect_to rarities_path, notice: t("rarities.updated")
    else
      render :edit
    end
  end

  def destroy
    @rarity.destroy
    redirect_to rarities_path, notice: t("rarities.deleted")
  end

  def get_rarities
    rarities = Rarity.all

    respond_to do |format|
      format.json { render json: { status: "success", data: rarities } }
    end
  end

  private

  def set_rarity
    @rarity = Rarity.find(params[:id])
  end

  def rarity_params
    params.require(:rarity).permit(:name, :min_price, :max_price, :min_power, :max_power)
  end
end
