class Admin::CharacterClassesController < Admin::BaseController
  before_action :set_character_class, only: [:show, :edit, :update, :destroy]

  def index
    classes = CharacterClass.search_by_name(params[:q])
                            .sorted(params[:sort], params[:dir])

    @pagy, @character_classes = pagy(classes, limit: parse_per_page)
  end

  def show
  end

  def new
    @character_class = CharacterClass.new
    @categories = Category.order(:name)
  end

  def create
    @character_class = CharacterClass.new(character_class_params)

    if @character_class.save
      save_affinities
      redirect_to admin_character_classes_path, notice: t("character_classes.created")
    else
      @categories = Category.order(:name)
      render :new
    end
  end

  def edit
    @categories = Category.order(:name)
  end

  def update
    if @character_class.update(character_class_params)
      save_affinities
      redirect_to admin_character_class_path(@character_class), notice: t("character_classes.updated")
    else
      @categories = Category.order(:name)
      render :edit
    end
  end

  def destroy
    @character_class.destroy
    redirect_to admin_character_classes_path, notice: t("character_classes.deleted")
  end

  private

  def set_character_class
    @character_class = CharacterClass.find(params[:id])
  end

  def character_class_params
    params.require(:character_class).permit(:name, :description, :is_magic_user)
  end

  def save_affinities
    @character_class.class_category_affinities.destroy_all

    (params[:affinities] || {}).each do |category_id, weight|
      next if weight.blank? || weight.to_i == 0
      @character_class.class_category_affinities.create!(
        category_id: category_id,
        weight: weight.to_i.clamp(1, 3)
      )
    end
  end
end
