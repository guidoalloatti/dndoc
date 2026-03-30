class Party < ApplicationRecord
  belongs_to :user
  has_many :characters, dependent: :destroy
  has_one_attached :image
  accepts_nested_attributes_for :characters, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validate :acceptable_image

  def has_image?
    image.attached?
  end

  private

  def acceptable_image
    return unless image.attached?

    unless image.blob.byte_size <= 5.megabytes
      errors.add(:image, I18n.t("profiles.avatar_too_large"))
    end

    acceptable_types = ["image/jpeg", "image/png", "image/gif", "image/webp"]
    unless acceptable_types.include?(image.blob.content_type)
      errors.add(:image, I18n.t("profiles.avatar_invalid_type"))
    end
  end
end
