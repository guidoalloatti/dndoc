class Character < ApplicationRecord
  belongs_to :party
  belongs_to :character_class

  has_many :items, dependent: :nullify
  has_one_attached :avatar

  validates :name, presence: true
  validates :level, numericality: { only_integer: true, in: 1..20 }
  validate :acceptable_avatar

  def has_avatar?
    avatar.attached?
  end

  def initials
    name.to_s.split.map(&:first).join.upcase[0, 2]
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
