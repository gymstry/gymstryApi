class NutritionRoutine < ApplicationRecord

  default_scope {order("nutrition_routines.name ASC")}
  scope :order_by_name, -> (ord) {"nutrition_routines.name #{ord}"}
  scope :order_by_start_date, -> (ord) {"nutrition_routines.start_date #{ord}"}
  scope :order_by_end_date, -> (ord) {"nutrition_routines.end_date #{ord}"}
  scope :order_by_created_at, -> (ord) {"nutrition_routines.created_at #{ord}"}
  scope :search_by_user_id, -> (id) {where(nutrition_routines:{user_id: id})}
  scope :search_by_trainer_id, -> (id) {where(nutrition_routines:{trainer_id: id})}

  belongs_to :user
  belongs_to :trainer, optional: true
  has_many :food_days, -> {reorder("food_days.type_food ASC")}, dependent: :destroy

  validates :name, :start_date, :end_date, presence: true
  validates :name, length: {minimum: 3}
  validate :valid_date

  def self.load_nutrition_routines(page = 1, per_page = 10)
    includes(user:[:challanges,:workouts,:medical_record],trainer: [:challanges,:workouts,:qualifications])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.nutrition_routine_by_id(id)
    includes(user:[:challanges,:workouts,:medical_record],trainer: [:challanges,:workouts,:qualifications])
      .find_by_id(id)
  end

  def self.nutrition_routines_by_name(name,page = 1 ,per_page = 10)
    load_nutrition_routines(page,per_page)
      .where("nutrition_routines.name LIKE ?", "#{name.downcase}%")
  end

  def self.nutrition_routines_by_ids(ids, page = 1, per_page = 10)
    load_nutrition_routines(page, per_page)
      .where(nutrition_routines:{id: ids})
  end

  def self.nutrition_routines_by_not(ids, page = 1, per_page = 10)
    load_nutrition_routines(page,per_page)
      .where.not(nutrition_routines:{id: ids})
  end

  def self.nutrition_routines_by_start_date(date, page = 1, per_page = 10)
    load_nutrition_routines(page,per_page)
      .where(nutrition_routines:{start_date: date})
  end

  def self.nutrition_routines_by_start_date_and_user_id(date,user,page = 1 ,per_page = 10)
    nutrition_routines_by_start_date(date,page,per_page)
      .search_by_user_id(user)
  end

  def self.nutrition_routines_by_start_date_and_trainer_id(date,trainer,page = 1, per_page = 10)
    nutrition_routines_by_start_date(date,page,per_page)
      .search_by_trainer_id(trainer)
  end

  def self.nutrition_routines_by_start_date_and_user_and_trainer_id(id,user,trainer,page = 1, per_page = 10)
    nutrition_routines_by_start_date(date,page,per_page)
      .search_by_trainer_id(trainer)
      .search_by_user_id(user)
  end

  def self.nutrition_routines_by_end_date(date, page = 1, per_page = 10)
    load_nutrition_routines(page,per_page)
      .where(nutrition_routines:{end_date: date})
  end

  def self.nutrition_routines_by_end_date_and_user_id(date,user,page = 1, per_page = 10)
    nutrition_routines_by_end_date(date,page, per_page)
      .search_by_user_id(user)
  end

  def self.nutrition_routines_by_end_date_and_trainer_id(date,trainer, page = 1, per_page = 10)
    nutrition_routines_by_end_date(date,page, per_page)
      .search_by_trainer_id(trainer)
  end

  def self.nutrition_routines_by_end_date_and_user_and_trainer_id(date,user,trainer,page = 1, per_page = 10)
    nutrition_routines_by_end_date(date,page, per_page)
      .search_by_trainer_id(trainer)
      .search_by_user_id(user)
  end

  def self.nutrition_routines_by_user_id(user,page = 1, per_page = 10)
    load_nutrition_routines(page, per_page)
      .search_by_user_id(user)
  end

  def self.nutrition_routines_by_trainer_id(trainer, page = 1, per_page = 10)
    load_nutrition_routines(page,per_page)
      .search_by_trainer_id(trainer)
  end

  def self.nutrition_routines_by_user_and_trainer_id(user,trainer, page = 1, per_page = 10)
    load_nutrition_routines(page,per_page)
      .search_by_user_id(user)
      .search_by_trainer_id(trainer)
  end

  protected
  def valid_date
    if start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be greater than start_date")
    end
  end
end
