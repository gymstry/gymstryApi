class MedicalRecord < ApplicationRecord
  belongs_to :user
  has_many :medical_record_by_disease, dependent: :destroy
  has_many :diseases, -> {(reorder("diseases.name ASC"))}, through: :medical_record_by_disease
  has_many :prohibited_exercises, dependent: :destroy
  has_many :exercises, -> {(reorder("exercises.name ASC"))}, through: :prohibited_exercises
end
