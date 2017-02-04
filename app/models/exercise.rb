class Exercise < ApplicationRecord

  default_scope {where(exercises:{owner: "admin"}).order("exercises.name")}
  scope :order_by_id, -> (ord) {order("exercises.id #{ord}")}
  scope :order_by_name, -> (ord) {order("exercises.name #{ord}")}
  scope :order_by_created_at, -> (ord) {order("exercises.created_at #{ord}")}
  scope :order_by_level, -> (ord) {order("exercies.level #{ord}")}
  scope :order_by_muscle_group, -> (ord) {order("exercies.muscle_group #{ord}")}

  has_many :images, as: :imageable, dependent: :destroy
  has_many :prohibited_exercises, dependent: :destroy
  has_many :medical_records, -> {(reorder("medical_records.created_at ASC"))}, through: :prohibited_exercises
  has_many :routines, dependent: :destroy
  belongs_to :trainer, optional: true

  #We need to add more groups
  enum muscle_group: {
    :biceps => 0,
    :triceps => 1,
    :back => 2
  }

  enum level: {
    :beginner => 0,
    :intermediate => 1,
    :advanced => 2
  }

  validates :name,:muscle_group,:level, presence: true
  validates :name, length: {minimum: 3}
  validates :muscle_group, inclusion: {in: muscle_groups.keys}
  validates :level, inclusion: {in: levels.keys}

  def self.load_exercises(page = 1, per_page = 10)
    includes(:images,medical_records: [:user],routines: [:workout_per_days])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.exercise_by_id(id)
    includes(:images,medical_records: [:user],routines: [:workout_per_days])
      find_by_id(id)
  end

  def self.exercises_by_name(name,page = 1, per_page = 10)
    load_exercises(page,per_page)
      .where("exercises.name LIKE ?", "#{name.downcase}%")
  end

  def self.exercises_by_ids(ids,page = 1, per_page = 10)
    load_exercises(page,per_page)
      .where(exercises: {id: ids})
  end

  def self.exercises_by_not_ids(ids,page = 1 ,per_page = 10)
    load_exercises(page,per_page)
      .where.not(exercises: {id: ids})
  end

  def self.exercises_with_images(page = 1,per_page = 10)
    joins(:pictures).select('exercises.*')
      .group("exercises.id")
      .paginate(:page => page, :per_page =>per_page)
      .reorder("count(pictures.id)")
  end

  def self.exercises_with_medical_records(page = 1, per_page = 10)
    joins(:prohibited_exercises).select("exercises.*")
      .group("exercises.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(prohibited_exercises.id)")
  end

  def self.exercises_with_routines(page = 1 ,per_page = 10)
    joins(:routines).select("exercies.*")
      .group("exercies.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(routines.id)")
  end

  def self.exercises_with_medical_records_by_id(id, page = 1, per_page = 10)
    load_exercises(page,per_page)
      .where(prohibited_exercises: {medical_record_id: id})
      .references(:prohibited_exercises)
  end

  def self.routines_with_workout_per_days(page = 1,per_page = 10)
    joins(:workout_per_day_per_exercises)
      .group("routines.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(workout_per_day_per_exercises.id)")
  end

end
