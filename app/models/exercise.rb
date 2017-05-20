class Exercise < ApplicationRecord

  default_scope {where(exercises:{owner: "admin"}).order("exercises.name")}
  scope :order_by_id, -> (ord) {order("exercises.id #{ord}")}
  scope :order_by_name, -> (ord) {order("exercises.name #{ord}")}
  scope :order_by_created_at, -> (ord) {order("exercises.created_at #{ord}")}
  scope :order_by_level, -> (ord) {order("exercises.level #{ord}")}
  scope :order_by_muscle_group, -> (ord) {order("exercises.muscle_group #{ord}")}
  scope :search_by_trainer, -> (id) {where(exercises:{branch_id: id})}

  has_many :images, as: :imageable, dependent: :destroy
  has_many :prohibited_exercises, dependent: :nullify
  has_many :medical_records, -> {(reorder("medical_records.created_at ASC"))}, through: :prohibited_exercises
  has_many :routines, dependent: :nullify
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

  def self.load_exercises(**args)
    params = (args[:exercise_params] || "exercises.*") + ","
    params = params + "exercises.id,exercises.trainer_id"
    includes(:images,medical_records: [:user],routines: [:workout_per_days])
      .select(params)
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.exercise_by_id(id,**args)
    params = (args[:exercise_params] || "exercises.*") + ","
    params = params + "exercises.id,exercises.trainer_id,exercises.updated_at"
    includes(:images,medical_records: [:user],routines: [:workout_per_days])
      .select(params)
      .find_by_id(id)
  end

  def self.exercises_by_search(name,**args)
    load_exercises(args)
      .where("exercises.name LIKE ?", "#{name.downcase}%")
  end

  def self.exercises_by_ids(ids,**args)
    load_exercises(args)
      .where(exercises: {id: ids})
  end

  def self.exercises_by_not_ids(ids,**args)
    load_exercises(args)
      .where.not(exercises: {id: ids})
  end

  def self.exercises_with_images(**args)
    joins(:images).select(args[:exercise_params] || "exercises.*")
      .select("count(images.id) AS images_count")
      .group("exercises.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(images.id)")
  end

  def self.exercises_with_medical_records(**args)
    joins(:prohibited_exercises).select(args[:exercise_params] || "exercises.*")
      .select("count(prohibited_exercises.id) as prohibited_exercises_count")
      .group("exercises.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(prohibited_exercises.id)")
  end

  def self.exercises_with_routines(**args)
    joins(:routines).select(args[:exercise_params] || "exercises.*")
      .select("count(routines.id) as routines_count")
      .group("exercises.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(routines.id)")
  end

  def self.exercises_available_user(ids, **args)
    exercises = joins(:prohibited_exercises).select(args[:exercise_params] || "exercises.*")
      .group("exercises.id")
      .paginate(:page => args[:page] || 1,:per_page => args[:per_page] || 10)
    if args[:trainer]
      exercises = exercises.where("exercises.owner = ? OR exercises.trainer_id = ?","admin",args[:trainer])
    else
      exercises = exercises.where("exercises.owner = ?", "admin")
    end
      exercises = exercises.where.not(prohibited_exercises: {exercise_id: ids})
  end

  def self.exercises_by_workout(id,**args)
    joins(routines: [:workout_per_days]).select(args[:exercise_params] || "exercises.*")
      .where(workout_per_days: {workout_id: id})
      .group("exercises.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
    #exercises_by_ids(exercises.ids,page,per_page)
  end

  def self.exercises_by_workout_per_day(id,**args)
    joins(routines: [:workout_per_days ]).select(args[:exercise_params] || "exercises.*")
      .where(workout_per_days: {workout_id: id})
      .where(workout_per_days: {order: args[:day] || 0})
      .group("exercises.id")
      .paginate(:page => args[:page] || 1,:per_page => args[:per_page] || 10)
    #exercises_by_ids(exercises.ids,{page: args[:page],per_page: args[:per_page]})
  end

end
