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
  has_many :food_days, -> {reorder("food_days.type_food ASC")}

  validates :name, :start_date, :end_date, presence: true
  validates :name, length: {minimum: 3}
  validate :valid_date

  def self.load_nutrition_routines(**args)
    includes(user:[:challanges,:workouts,:medical_record],trainer: [:challanges,:workouts,:qualifications])
      .select(args[:nutrition_routine_params] || "nutrition_routines.*")
      .paginate(:page => args[:page], :per_page => args[:per_page])
  end

  def self.nutrition_routine_by_id(id)
    includes(user:[:challanges,:workouts,:medical_record],trainer: [:challanges,:workouts,:qualifications])
      .select(args[:nutrition_routine_params] || "nutrition_routines.*")
      .find_by_id(id)
  end

  def self.nutrition_routines_by_name(name,**args)
    load_nutrition_routines(args)
      .where("nutrition_routines.name LIKE ?", "#{name.downcase}%")
  end

  def self.nutrition_routines_by_ids(ids, **args)
    load_nutrition_routines(args)
      .where(nutrition_routines:{id: ids})
  end

  def self.nutrition_routines_by_not_ids(ids, **args)
    load_nutrition_routines(args)
      .where.not(nutrition_routines:{id: ids})
  end

  def self.nutrition_routines_by_start_date(date, **args)
    load_nutrition_routines(args)
      .where(nutrition_routines:{start_date: date})
  end

  def self.nutrition_routines_by_start_date_and_user_id(date,**args)
    nutrition_routines_by_start_date(date,{page: args[:page],per_page: args[:per_page]})
      .search_by_user_id(args[:user])
  end

  def self.nutrition_routines_by_start_date_and_trainer_id(date,**args)
    nutrition_routines_by_start_date(date,{page: args[:page],per_page: args[:per_page]})
      .search_by_trainer_id(args[:trainer])
  end

  def self.nutrition_routines_by_start_date_and_user_and_trainer_id(date,**args)
    nutrition_routines_by_start_date(date,{page: args[:page],per_page: args[:per_page]})
      .search_by_trainer_id(args[:trainer])
      .search_by_user_id(args[:per_page])
  end

  def self.nutrition_routines_by_end_date(date, **args)
    load_nutrition_routines(args)
      .where(nutrition_routines:{end_date: date})
  end

  def self.nutrition_routines_by_end_date_and_user_id(date,**args)
    nutrition_routines_by_end_date(date,{page: args[:page],per_page: args[:per_page]})
      .search_by_user_id(args[:user])
  end

  def self.nutrition_routines_by_end_date_and_trainer_id(date,**args)
    nutrition_routines_by_end_date(date,{page: args[:page],per_page: args[:per_page]})
      .search_by_trainer_id(args[:trainer])
  end

  def self.nutrition_routines_by_end_date_and_user_and_trainer_id(date,**args)
    nutrition_routines_by_end_date(date,{page: args[:page],per_page: args[:per_page]})
      .search_by_trainer_id(args[:trainer])
      .search_by_user_id(args[:user])
  end

  def self.nutrition_routines_by_user_id(user,**args)
    load_nutrition_routines(args)
      .search_by_user_id(user)
  end

  def self.nutrition_routines_by_trainer_id(trainer, **args)
    load_nutrition_routines(args)
      .search_by_trainer_id(trainer)
  end

  def self.nutrition_routines_by_user_and_trainer_id(user,**args)
    load_nutrition_routines({page: args[:page],per_page: args[:per_page]})
      .search_by_user_id(user)
      .search_by_trainer_id(args[:trainer])
  end

  def self.nutrition_routine_with_food_day(**args)
    joins(:food_days).select(args[:nutrition_routine_params] || "nutrition_routines.*")
      .group("nutrition_routines.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  protected
  def valid_date
    if !start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if !start_date && !end_date && start_date > end_date
      errors.add(:end_date, "must be greater than start_date")
    end
  end
end
