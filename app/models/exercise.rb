class Exercise < ApplicationRecord
  belongs_to :workout_per_day
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :prohibited_exercises, dependent: :destroy
  has_many :medical_records, -> {(reorder("medical_records.created_at ASC"))}, through: :prohibited_exercises
end
