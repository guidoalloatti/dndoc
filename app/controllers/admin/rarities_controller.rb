module Admin
  class RaritiesController < BaseController
    before_action :set_rarity, only: [:edit, :update, :destroy]

    def index
      @rarities = Rarity.order(:min_power)
    end

    def new
      @rarity = Rarity.new
    end

    def create
      @rarity = Rarity.new(rarity_params)
      if @rarity.save
        redirect_to admin_rarities_path, notice: t('admin.rarities.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @rarity.update(rarity_params)
        redirect_to admin_rarities_path, notice: t('admin.rarities.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @rarity.destroy
      redirect_to admin_rarities_path, notice: t('admin.rarities.deleted')
    end

    private

    def set_rarity
      @rarity = Rarity.find(params[:id])
    end

    def rarity_params
      params.require(:rarity).permit(:name, :min_price, :max_price, :min_power, :max_power)
    end
  end
end
