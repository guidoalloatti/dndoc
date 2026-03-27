class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Google-linked users can update email/name without providing current password
  def update_resource(resource, params)
    if resource.google_linked? && params[:password].blank?
      resource.update_without_password(params)
    else
      super
    end
  end
end
