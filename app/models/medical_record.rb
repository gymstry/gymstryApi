class MedicalRecord < ApplicationRecord

  default_scope {order("medical_records.created_at  ASC")}

  belongs_to :user
  has_many :medical_record_by_disease, dependent: :destroy
  has_many :diseases, -> {(reorder("diseases.name ASC"))}, through: :medical_record_by_disease
  has_many :prohibited_exercises, dependent: :destroy
  has_many :exercises, -> {(reorder("exercises.name ASC"))}, through: :prohibited_exercises

  validates :weight,:chest,:hips,:waist,:body_fat_percentage,presence: true
  validates :weight,:chest,:hips,:waist,:body_fat_percentage,numericality: { greater_than_or_equal: 0 }
  
end
