class WeaponsController < ApplicationController
  before_action :set_weapon, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    weapons = Weapon.search_by_name(params[:q])
                    .by_damage(params[:damage])
                    .sorted(params[:sort], params[:dir])

    @pagy, @weapons = pagy(weapons, limit: parse_per_page)
    @damage_types = Weapon.distinct.order(:damage).pluck(:damage)
  end

  def show
  end

  def new
    @weapon = Weapon.new
  end

  def create
    @weapon = Weapon.new(weapon_params)
    if @weapon.save
      redirect_to @weapon, notice: t("weapons.created")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @weapon.update(weapon_params)
      redirect_to @weapon, notice: t("weapons.updated")
    else
      render :edit
    end
  end

  def destroy
    @weapon.destroy
    redirect_to weapons_path, notice: t("weapons.deleted")
  end

  private

  def set_weapon
    @weapon = Weapon.find(params[:id])
  end

  def weapon_params
    params.require(:weapon).permit(:name, :cost, :damage, :weight, :properties)
  end
end
