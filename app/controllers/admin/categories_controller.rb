module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: [:edit, :update, :destroy]

    def index
      @q    = params[:q]
      cats  = Category.order(:name)
      cats  = cats.where("name ILIKE ?", "%#{@q}%") if @q.present?
      @pagy, @categories = pagy(cats, limit: parse_per_page(50))
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: t('admin.categories.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: t('admin.categories.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: t('admin.categories.deleted')
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description, :min_weight, :max_weight, :image)
    end
  end
end
