class Food < ApplicationRecord

  default_scope {order("foods.name ASC")}
  validates :count,numericality: { greater_than_or_equal: 1 }

  belongs_to :food_day, optional: true

  validates :name, :proteins,:carbohydrates,:fats, presence: true
  validates :name, uniqueness: true
  validates :name, length: {minimum: 3}
  validates :proteins,:carbohydrates,:fats,numericality: { greater_than_or_equal: 0 }

end
