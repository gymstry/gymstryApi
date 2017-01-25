class Food < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope {order("foods.name ASC")}
  scope :order_by_id, -> (ord) {order("foods.id #{ord}")}
  scope :order_by_name, -> (ord) {order("foods.name #{ord}")}
  scope :order_by_proteins, -> (ord) {order("foods.proteins #{ord}")}
  scope :order_by_carbohydrates, -> (ord) {order("foods.carbohydrates #{ord}")}
  scope :order_by_fats, -> (ord) {order("foods.fats #{ord}")}
  scope :order_by_created_at, -> (ord) {order("foods.created_at, #{ord}")}

  has_many :food_day_per_foods, dependent: :destroy
  has_many :food_days, through: :food_day_per_foods

  validates :name, :proteins,:carbohydrates,:fats, presence: true
  validates :name, uniqueness: true
  validates :name, length: {minimum: 3}
  validates :proteins,:carbohydrates,:fats,numericality: { greater_than_or_equal: 0 }
  validates_integrity_of :image
  validates_processing_of :image
  validates :image, file_size: { less_than_or_equal_to: 1.megabyte }

  def self.load_foods(page = 1, per_page = 10)
    includes(food_days: [:nutrition_routine])
      .paginate(:page => page, :per_page =>per_page)
  end

  def self.food_by_id(id)
    includes(food_days: [:nutrition_routine])
      .find_by_id(id)
  end

  def self.foods_by_name(name)
    load_foods(page,per_page)
      .where("foods.name LIKE ?", "#{name.downcase}%")
  end

  def self.foods_by_ids(ids,page = 1, per_page = 10)
    load_foods(page,per_page)
      .where(foods:{id: ids})
  end

  def self.foods_by_not_ids(ids,page = 1, per_page = 10)
    load_foods(page,per_page)
      .where.not(foods:{id: ids})
  end

  def self.foods_by_proteins_greater_than(proteins, page = 1, per_page = 10)
    load_foods(page,per_page)
      .where("foods.proteins > ?", proteins)
  end

  def self.foods_by_carbohydrates_greater_than(carbohydrates, page = 1, per_page = 10)
    load_foods(page,per_page)
      .where("foods.carbohydrates > ?", carbohydrates)
  end

  def self.foods_by_fats_greater_than(fats, page = 1, per_page = 10)
    load_foods(page,per_page)
      .where("foods.fats > ?", fats)
  end

  def self.foods_with_food_days(page = 1, per_page = 10)
    joins(:food_day_per_foods)
      .group("foods.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(food_day_per_foods.id)")
  end

  def self.foods_with_food_days_by_id(id, page = 1, per_page = 10)
    load_foods(page,per_page)
      .where(food_day_per_foods:{food_day_id: id})
      .references(:food_day_per_foods)
  end

end
