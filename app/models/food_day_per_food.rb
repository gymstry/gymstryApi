class FoodDayPerFood < ApplicationRecord
  belongs_to :food
  belongs_to :food_day
end
