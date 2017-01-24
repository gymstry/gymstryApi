class NutritionRoutine < ApplicationRecord
  belongs_to :user
  belongs_to :trainer
  has_many :food_days, -> {reorder("food_days.type_food ASC")}, dependent: :destroy
end
