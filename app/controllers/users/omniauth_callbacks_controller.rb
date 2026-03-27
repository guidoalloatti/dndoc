class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    existing_by_email = User.find_by(email: auth.info.email)
    was_linked = existing_by_email.present? && existing_by_email.provider.blank?

    @user = User.from_omniauth(auth)

    if @user.persisted?
      if was_linked
        flash[:notice] = I18n.t("devise.omniauth_callbacks.linked", email: @user.email)
      else
        flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "Google")
      end
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: I18n.t("devise.omniauth_callbacks.failure", kind: "Google", reason: failure_message)
  end
end
