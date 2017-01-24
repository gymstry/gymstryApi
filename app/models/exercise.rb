class Exercise < ApplicationRecord

  default_scope {order("exercises.name")}

  belongs_to :workout_per_day, optional: true
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :prohibited_exercises, dependent: :destroy
  has_many :medical_records, -> {(reorder("medical_records.created_at ASC"))}, through: :prohibited_exercises

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
  validates :level, inclusion: {in: {levels.keys}}
  
end
