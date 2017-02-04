class Challange < ApplicationRecord
  before_create :set_state

  default_scope {order("challanges.name ASC")}
  scope :order_by_id, -> (ord) {order("challanges.id #{ord}")}
  scope :order_by_name, -> (ord) {order("challanges.name #{ord}")}
  scope :order_by_created_at, -> (ord) {order("challanges.created_at #{ord}")}
  scope :order_by_state, -> (ord) {order("challanges.state #{ord}")}
  scope :order_by_type, -> (ord) {order("challanges.type_challange #{ord}")}
  scope :order_by_start_date, -> (ord) {order("challanges.start_date #{ord}")}
  scope :order_by_end_date, -> (ord) {order("challanges.end_date #{ord}")}
  scope :search_by_user_id, -> (id) {where(challanges:{user_id: id})}
  scope :search_by_trainer_id, -> (id) {where(challanges:{user_id: id})}

  belongs_to :trainer, optional: true
  belongs_to :user

  #Thanks to the enums we have some methods out of the box, I mean self.passed -> where(state = 'passed')
  enum state: {
    :progress => 0,
    :passed => 1,
    :failed => 2
  }

  enum type_challange: {
    :weight => 0,
    :eat_carbohydrates => 1,
    :eat_proteins => 2,
    :eat_fats => 3,
    :hip => 4,
    :chest => 5,
    :body_fat_percentage => 6,
    :waist => 7
  }

  validates :name, :start_date, :end_date, :objective, :type_challange, presence: true
  validates :state, inclusion: {in: states.keys}
  validates :type_challange, inclusion: {in: type_challanges.keys}
  validates :name, length: {minimum: 3}
  validate :valid_date

  def self.load_challanges(page = 1, per_page = 10)
    includes(user: [:medical_record,:challanges,:workouts,:nutrition_routines],trainer: [:qualifications,:challanges,:workouts,:nutrition_routines])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.challange_by_id(id)
    includes(user: [:medical_record,:challanges,:workouts,:nutrition_routines],trainer: [:qualifications,:challanges,:workouts,:nutrition_routines])
      .find_by_id(id)
  end

  def self.challange_by_name(name,page = 1,per_page = 10)
    load_challanges(page,per_page)
      .where("challanges.name LIKE ?", "#{name.downcase}%")
  end

  def self.challanges_by_start_date(date, page = 1, per_page = 10)
    load_challanges(page,per_page)
      .where(challanges: {start_date: date})
  end

  def self.challanges_by_start_date_and_trainer(date,trainer,page = 1 ,per_page = 10)
    challanges_by_start_date(date,page,per_page)
      .search_by_trainer_id(trainer)
  end

  def self.challanges_by_start_date_and_user(date,user, page = 1, per_page = 10)
    challanges_by_start_date(date,page,per_page)
      .search_by_user_id(user)
  end

  def self.challanges_by_start_date_and_user_and_trainer(date,user,trainer,page = 1, per_page = 10)
    challanges_by_start_date(date,page,per_page)
      .search_by_user_id(user)
      .search_by_trainer_id(trainer)
  end

  def self.challanges_by_end_date(date, page = 1, per_page = 10)
    load_challanges(page,per_page)
      .where(challanges: {end_date: date})
  end

  def self.challanges_by_end_date_and_trainer(date, trainer, page = 1, per_page = 10)
    challanges_by_end_date(date,page,per_page)
      .search_by_trainer_id(trainer)
  end

  def self.challanges_by_end_date_and_user(date, user, page = 1 ,per_page = 10)
    challanges_by_end_date(date,page,per_page)
      .search_by_user_id(user)
  end

  def self.challanges_by_end_date_and_user_and_trainer(date,user,trainer,page = 1, per_page = 10)
    challanges_by_end_date(date,page,per_page)
      .search_by_user_id(user)
      .search_by_trainer_id(trainer)
  end

  def self.challanges_by_user_id(user_id, page = 1, per_page = 10)
    load_challanges(page,per_page).search_by_user_id(user_id)
  end

  def self.challanges_by_trainer_id(trainer_id, page = 1, per_page = 10)
    load_challanges(page,per_page).search_by_trainer_id(trainer_id)
  end

  def self.challanges_by_user_and_trainer_id(user,trainer, page = 1, per_page = 10)
    load_challanges(page,per_page).search_by_user_id(user).search_by_trainer_id(trainer)
  end

  def self.challanges_by_ids(ids,page = 1, per_page = 10)
    load_challanges(page,per_page)
      .where(challanges: {id: ids})
  end

  def self.challanges_by_not_ids(ids,page = 1, per_page = 10)
    load_challanges(page,per_page)
      .where.not(challanges: {id: ids})
  end

  protected
  def set_state
    self.state = Challange.states["progress"]
  end

  def valid_date
    if start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be greater than start_date")
    end
  end

end
