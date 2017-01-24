class Workout < ApplicationRecord

  default_scope {order("workouts.name ASC")}

  belongs_to :user
  belongs_to :trainer
  has_many :workout_per_day, -> {reorder("workout_per_days.name ASC")}, dependent: :destroy

  enum level:{
    :beginner => 0,
    :intermediate => 1,
    :advanced => 2
  }

  validates :name, :start_date, :end_date,:days,:level,presence: true
  validates :name, length: {minimum: 3}
  validates :level, inclusion: {in: levels.keys}
  validates_inclusion_of :days, in: 1..7
  validate :valid_date

  def valid_date
    if start_date && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be greater than start_date")
    end
  end
end
