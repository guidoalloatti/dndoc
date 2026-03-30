class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character, only: [:show, :edit, :update, :destroy, :assign_item, :unassign_item]
  before_action :load_form_data, only: [:new, :create, :edit, :update]

  def index
    @characters = Character.joins(:party)
                           .where(parties: { user_id: current_user.id })
                           .includes(:character_class, :party, :items)
                           .order("parties.name, characters.name")
  end

  def show
    @items = @character.items.includes(:category, :rarity, :effects).order(created_at: :desc)
  end

  def new
    if params[:party_id]
      party = current_user.parties.find(params[:party_id])
      @character = party.characters.build(level: 1)
    else
      @character = Character.new(level: 1)
    end
  end

  def create
    @character = Character.new(character_params)

    # Verify party belongs to current user
    unless current_user.parties.exists?(id: @character.party_id)
      redirect_to characters_path, alert: t("shared.not_authorized") and return
    end

    if @character.save
      redirect_to character_path(@character), notice: t("characters.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # If changing party, verify ownership
    if character_params[:party_id].present? && !current_user.parties.exists?(id: character_params[:party_id])
      redirect_to character_path(@character), alert: t("shared.not_authorized") and return
    end

    if @character.update(character_params)
      redirect_to character_path(@character), notice: t("characters.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    party = @character.party
    @character.destroy
    redirect_to party_path(party), notice: t("characters.destroyed")
  end

  def assign_item
    item = current_user.items.find(params[:item_id])
    item.update!(character: @character)
    redirect_to character_path(@character), notice: t("characters.item_assigned")
  end

  def unassign_item
    item = @character.items.find(params[:item_id])
    item.update!(character: nil)
    redirect_to character_path(@character), notice: t("characters.item_unassigned")
  end

  private

  def set_character
    @character = Character.joins(:party)
                          .where(parties: { user_id: current_user.id })
                          .includes(:character_class, :party, items: [:category, :rarity, :effects])
                          .find(params[:id])
  end

  def load_form_data
    @character_classes = CharacterClass.order(:name)
    @parties = current_user.parties.order(:name)
  end

  def character_params
    params.require(:character).permit(:name, :race, :level, :character_class_id, :party_id, :avatar)
  end
end
