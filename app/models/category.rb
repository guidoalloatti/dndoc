class Category < ApplicationRecord
  has_many :items, dependent: :destroy
  has_and_belongs_to_many :effects

  validates :name, presence: true
end
