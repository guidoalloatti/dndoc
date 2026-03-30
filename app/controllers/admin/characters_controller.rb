module Admin
  class CharactersController < BaseController
    before_action :set_character, only: [:show, :destroy]

    def index
      @q    = params[:q]
      chars = Character.includes(:party, :character_class, :items)
      chars = chars.where("characters.name ILIKE ?", "%#{@q}%") if @q.present?
      chars = chars.order(created_at: :desc)
      @pagy, @characters = pagy(chars, limit: parse_per_page(50))
    end

    def show; end

    def destroy
      @character.destroy
      redirect_to admin_characters_path, notice: t('admin.characters.deleted')
    end

    private

    def set_character
      @character = Character.includes(:party, :character_class, :items).find(params[:id])
    end
  end
end
