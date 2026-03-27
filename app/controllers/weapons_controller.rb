class WeaponsController < ApplicationController
  def index
    weapons = Weapon.search_by_name(params[:q])
                    .by_damage(params[:damage])
                    .sorted(params[:sort], params[:dir])

    per_page = [params[:per_page].to_i, 10].max rescue 20
    per_page = [per_page, 100].min
    @pagy, @weapons = pagy(weapons, limit: per_page)
    @damage_types = Weapon.distinct.order(:damage).pluck(:damage)
  end

  def show
    @weapon = Weapon.find(params[:id])
  end

  def new
    @weapon = Weapon.new
  end

  def create
    @weapon = Weapon.new(weapon_params)
    if @weapon.save
      redirect_to @weapon, notice: "Weapon successfully created."
    else
      render :new
    end
  end

  def edit
    @weapon = Weapon.find(params[:id])
  end

  def update
    @weapon = Weapon.find(params[:id])
    if @weapon.update(weapon_params)
      redirect_to @weapon, notice: "Weapon successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @weapon = Weapon.find(params[:id])
    @weapon.destroy
    redirect_to weapons_path, notice: "Weapon successfully deleted."
  end

  private

  def weapon_params
    params.require(:weapon).permit(:name, :cost, :damage, :weight, :properties)
  end
end
