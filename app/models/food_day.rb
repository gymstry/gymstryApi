class FoodDay < ApplicationRecord
  default_scope {order("food_days.created_at ASC")}

  belongs_to :nutrition_routine
  has_many :foods, -> {reorder("foods.name ASC")}

  enum type_food: {
    :breakfast => 0,
    :lunch => 1,
    :dinner => 2,
    :snack => 3
  }
  
  validates :type_food, presence: true
  validates :type_food, inclusion: {in: type_foods.keys}

end
