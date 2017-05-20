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

  def self.load_foods(**args)
    params = (args[:food_params]|| "foods.*") + ","
    params = params + "foods.id"
    includes(food_days: [:nutrition_routine])
      .select(params)
      .paginate(:page => args[:page] || 1, :per_page =>args[:per_page] || 10)
  end

  def self.food_by_id(id,**args)
    params = (args[:food_params] || "foods.*") + ","
    params = params + "foods.id,foods.updated_at"
    includes(food_days: [:nutrition_routine])
      .select(params)
      .find_by_id(id)
  end

  def self.foods_by_search(search,**args)
    load_foods(args)
      .where("foods.name LIKE ?", "#{search.downcase}%")
  end

  def self.foods_by_ids(ids,**args)
    load_foods(**args)
      .where(foods:{id: ids})
  end

  def self.foods_by_not_ids(ids,**args)
    load_foods(args)
      .where.not(foods:{id: ids})
  end

  def self.foods_by_proteins_greater_than(proteins,**args)
    load_foods(args)
      .where("foods.proteins > ?", proteins || 0)
  end

  def self.foods_by_carbohydrates_greater_than(carbohydrates, **args)
    load_foods(args)
      .where("foods.carbohydrates > ?", carbohydrates || 0)
  end

  def self.foods_by_fats_greater_than(fats, **args)
    load_foods(args)
      .where("foods.fats > ?", fats || 0)
  end

  def self.foods_with_food_days(**args)
    joins(:food_day_per_foods).select(args[:food_params] ||  "foods.*")
      .select("count(food_day_per_foods.food_day_id) as food_days_count")
      .group("foods.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page])
      .reorder("count(food_day_per_foods.id)")
  end

  def self.foods_with_food_days_by_food_id(id, **args)
    joins(:food_day_per_foods).select(args[:food_params] ||  "foods.*")
      .group("foods.id")
      .where(food_day_per_foods: {
          food_day: id
      })
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page])
      .reorder("count(food_day_per_foods.id)")
  end

end
