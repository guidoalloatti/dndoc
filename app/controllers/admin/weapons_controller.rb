module Admin
  class WeaponsController < BaseController
    before_action :set_weapon, only: [:edit, :update, :destroy]

    def index
      @q       = params[:q]
      weapons  = Weapon.order(:name)
      weapons  = weapons.where("name ILIKE ?", "%#{@q}%") if @q.present?
      @pagy, @weapons = pagy(weapons, limit: parse_per_page(50))
    end

    def new
      @weapon = Weapon.new
    end

    def create
      @weapon = Weapon.new(weapon_params)
      if @weapon.save
        redirect_to admin_weapons_path, notice: t('admin.weapons.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @weapon.update(weapon_params)
        redirect_to admin_weapons_path, notice: t('admin.weapons.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @weapon.destroy
      redirect_to admin_weapons_path, notice: t('admin.weapons.deleted')
    end

    private

    def set_weapon
      @weapon = Weapon.find(params[:id])
    end

    def weapon_params
      params.require(:weapon).permit(:name, :cost, :damage, :weight, :properties)
    end
  end
end
