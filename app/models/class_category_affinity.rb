class ClassCategoryAffinity < ApplicationRecord
  belongs_to :character_class
  belongs_to :category

  validates :weight, inclusion: { in: 1..3 }
  validates :character_class_id, uniqueness: { scope: :category_id }
end
