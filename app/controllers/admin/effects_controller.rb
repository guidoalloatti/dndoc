module Admin
  class EffectsController < BaseController
    before_action :set_effect, only: [:edit, :update, :destroy]

    def index
      @q           = params[:q]
      @type_filter = params[:effect_type]

      effects = Effect.order(:effect_type, :name)
      effects = effects.where("name ILIKE ? OR name_es ILIKE ?", "%#{@q}%", "%#{@q}%") if @q.present?
      effects = effects.where(effect_type: @type_filter) if @type_filter.present?

      @pagy, @effects = pagy(effects, limit: parse_per_page(50))
      @effect_types   = Effect.distinct.order(:effect_type).pluck(:effect_type)
    end

    def new
      @effect = Effect.new
    end

    def create
      @effect = Effect.new(effect_params)
      if @effect.save
        redirect_to admin_effects_path, notice: t('admin.effects.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @effect.update(effect_params)
        redirect_to admin_effects_path, notice: t('admin.effects.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @effect.destroy
      redirect_to admin_effects_path, notice: t('admin.effects.deleted')
    end

    private

    def set_effect
      @effect = Effect.find(params[:id])
    end

    def effect_params
      params.require(:effect).permit(:name, :description, :effect_type, :power_level, :name_es, :description_es)
    end
  end
end
