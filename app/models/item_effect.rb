# app/models/item_effect.rb
class ItemEffect < ApplicationRecord
  belongs_to :item
  belongs_to :effect
end
