class FoodDay < ApplicationRecord
  default_scope {order("food_days.created_at ASC")}
  scope :order_by_id, -> (ord) {order("food_days.id #{ord}")}
  scope :order_by_type, -> (ord) {order("food_days.type_food #{ord}")}
  scope :order_by_created_at, -> (ord) {order("food_days.created_at #{ord}")}
  scope :search_by_nutrition_routine_id, -> (id) {where(food_days:{nutrition_routine_id:id})}

  belongs_to :nutrition_routine
  has_many :food_day_per_foods
  has_many :foods, -> {reorder("foods.name ASC")}, through: :food_day_per_foods

  enum type_food: {
    :breakfast => 0,
    :lunch => 1,
    :dinner => 2,
    :snack => 3
  }

  validates :type_food, presence: true
  validates :type_food, inclusion: {in: type_foods.keys}

  def self.load_food_days(page = 1,per_page = 10)
    includes(:foods,nutrition_routine: [:user,:trainer])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.fodd_day_by_id(id)
    includes(:foods,nutrition_routine: [:user,:trainer])
      .find_by_id(id)
  end

  def self.food_days_by_ids(ids, page = 1, per_page = 10)
    load_food_days(page,per_page)
      .where(food_days: {id: ids})
  end

  def self.food_days_by_not_ids(ids, page = 1, per_page = 10)
    load_food_days(page,per_page)
      .where.not(food_days: {id: ids})
  end

  def self.food_days_by_nutrition_routine(id, page = 1, per_page = 10)
    load_food_days(page,per_page).search_by_nutrition_routine_id(id)
  end

  def self.food_days_with_foods(page = 1,per_page = 10)
    joins(:food_day_per_foods).select("food_days.*")
      .group("food_days.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(food_day_per_foods.id)")
  end

end
