module Admin
  class PartiesController < BaseController
    before_action :set_party, only: [:show, :destroy]

    def index
      @q       = params[:q]
      parties  = Party.includes(:user, :characters)
      parties  = parties.where("parties.name ILIKE ?", "%#{@q}%") if @q.present?
      parties  = parties.order(created_at: :desc)
      @pagy, @parties = pagy(parties, limit: parse_per_page(50))
    end

    def show; end

    def destroy
      @party.destroy
      redirect_to admin_parties_path, notice: t('admin.parties.deleted')
    end

    private

    def set_party
      @party = Party.includes(:user, characters: [:character_class, :items]).find(params[:id])
    end
  end
end
