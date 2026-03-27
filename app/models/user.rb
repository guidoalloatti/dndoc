class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :items, dependent: :nullify
  has_one_attached :avatar

  validate :acceptable_avatar

  def self.from_omniauth(auth)
    # First try to find by provider+uid (returning Google user)
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # Then check if a user with this email already exists (manual registration)
    user = find_by(email: auth.info.email)
    if user
      # Link the existing account to Google and complete the login
      user.update!(
        provider: auth.provider,
        uid: auth.uid,
        avatar_url: auth.info.image.presence || user.avatar_url,
        first_name: user.first_name.presence || auth.info.first_name,
        last_name: user.last_name.presence || auth.info.last_name,
      )
      return user
    end

    # Otherwise create a brand new user
    create!(
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      avatar_url: auth.info.image,
      provider: auth.provider,
      uid: auth.uid,
    )
  end

  def full_name
    [first_name, last_name].compact_blank.join(" ").presence || email
  end

  def initials
    if first_name.present? || last_name.present?
      [first_name&.first, last_name&.first].compact.join.upcase
    else
      email.first.upcase
    end
  end

  def display_avatar
    if avatar.attached?
      avatar
    elsif avatar_url.present?
      avatar_url
    end
  end

  def has_avatar?
    avatar.attached? || avatar_url.present?
  end

  def google_linked?
    provider == "google_oauth2"
  end

  def admin?
    admin
  end

  # Skip current_password validation for Google-linked users who never set a password
  def update_without_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      result = update(params, *options)
      clean_up_passwords
      result
    else
      super
    end
  end

  private

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.blob.byte_size <= 5.megabytes
      errors.add(:avatar, I18n.t("profiles.avatar_too_large"))
    end

    acceptable_types = ["image/jpeg", "image/png", "image/gif", "image/webp"]
    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, I18n.t("profiles.avatar_invalid_type"))
    end
  end
end
