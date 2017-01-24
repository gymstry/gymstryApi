class FoodDay < ApplicationRecord
  belongs_to :nutrition_routine
  has_many :foods, -> {reorder("foods.name ASC")}
end
