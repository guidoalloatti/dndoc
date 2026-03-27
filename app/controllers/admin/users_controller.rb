module Admin
  class UsersController < BaseController
    include Pagy::Backend

    def index
      users = User.left_joins(:items)
                   .select("users.*, COUNT(items.id) as items_count")
                   .group("users.id")

      if params[:search].present?
        q = "%#{params[:search]}%"
        users = users.where("users.email ILIKE :q OR users.first_name ILIKE :q OR users.last_name ILIKE :q", q: q)
      end

      users = users.where(admin: true) if params[:role] == "admin"
      users = users.where(admin: false) if params[:role] == "user"

      users = users.order(created_at: :desc)
      @pagy, @users = pagy(users, limit: 20)
    end

    def show
      @user = User.find(params[:id])
      @pagy, @items = pagy(
        @user.items.includes(:category, :rarity, :effects).order(created_at: :desc),
        limit: 12
      )
    end

    def toggle_admin
      @user = User.find(params[:id])

      if @user == current_user
        redirect_to admin_users_path, alert: t("admin.cannot_change_self")
        return
      end

      @user.update!(admin: !@user.admin?)
      redirect_to admin_users_path,
        notice: t("admin.role_updated", name: @user.full_name, role: @user.admin? ? "Admin" : "User")
    end
  end
end
