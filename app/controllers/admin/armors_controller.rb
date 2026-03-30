module Admin
  class ArmorsController < BaseController
    before_action :set_armor, only: [:edit, :update, :destroy]

    def index
      @q      = params[:q]
      @type   = params[:armor_type]
      armors  = Armor.order(:armor_type, :name)
      armors  = armors.where("name ILIKE ?", "%#{@q}%") if @q.present?
      armors  = armors.where(armor_type: @type) if @type.present?
      @pagy, @armors = pagy(armors, limit: parse_per_page(50))
    end

    def new
      @armor = Armor.new
    end

    def create
      @armor = Armor.new(armor_params)
      if @armor.save
        redirect_to admin_armors_path, notice: t('admin.armors.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @armor.update(armor_params)
        redirect_to admin_armors_path, notice: t('admin.armors.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @armor.destroy
      redirect_to admin_armors_path, notice: t('admin.armors.deleted')
    end

    private

    def set_armor
      @armor = Armor.find(params[:id])
    end

    def armor_params
      params.require(:armor).permit(
        :name, :armor_type, :armor_class, :cost, :weight,
        :str_requirement, :stealth_disadvantage, :properties
      )
    end
  end
end
