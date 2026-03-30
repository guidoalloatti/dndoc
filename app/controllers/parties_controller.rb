class PartiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_party, only: [:show, :edit, :update, :destroy, :load_data]

  def index
    @parties = current_user.parties.includes(characters: :character_class).order(:name)
  end

  def new
    @party = current_user.parties.build
    @party.characters.build
    @character_classes = CharacterClass.order(:name)
  end

  def create
    @party = current_user.parties.build(party_params)
    @character_classes = CharacterClass.order(:name)
    if @party.save
      redirect_to party_path(@party), notice: t("parties.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @party = current_user.parties
               .includes(characters: [:character_class, items: [:category, :rarity, :effects]])
               .find(params[:id])
  end

  def edit
    @character_classes = CharacterClass.order(:name)
  end

  def update
    @character_classes = CharacterClass.order(:name)
    if @party.update(party_params)
      redirect_to party_path(@party), notice: t("parties.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @party.destroy
    redirect_to parties_path, notice: t("parties.destroyed")
  end

  def load_data
    render json: {
      id: @party.id,
      name: @party.name,
      characters: @party.characters.includes(:character_class).order(:id).map { |c|
        {
          id: c.id,
          name: c.name,
          race: c.race,
          level: c.level,
          character_class_id: c.character_class_id,
          character_class_name: c.character_class.name,
        }
      },
    }
  end

  private

  def set_party
    @party = current_user.parties.find(params[:id])
  end

  def party_params
    params.require(:party).permit(
      :name, :image,
      characters_attributes: [:id, :name, :race, :level, :character_class_id, :_destroy],
    )
  end
end
