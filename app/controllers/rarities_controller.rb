class RaritiesController < ApplicationController
  before_action :set_rarity, only: [:show, :edit, :update, :destroy]

  def index
    @rarities = Rarity.all
  end

  def new
    @rarity = Rarity.new
  end

  def create
    @rarity = Rarity.new(rarity_params)
    if @rarity.save
      redirect_to rarities_path, notice: "Rarity created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @rarity.update(rarity_params)
      redirect_to rarities_path, notice: "Rarity updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @rarity.destroy
    redirect_to rarities_path, notice: "Rarity deleted successfully."
  end

  def get_rarities
    rarities = Rarity.all

    respond_to do |format|
      format.json { render json: { status: 'success', data: rarities }}
    end
  end

  private

  def set_rarity
    @rarity = Rarity.find(params[:id])
  end

  def rarity_params
    params.require(:rarity).permit(:name, :min_price, :max_price)
  end
end
