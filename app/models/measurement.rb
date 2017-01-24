class Measurement < ApplicationRecord

  default_scope {order("measurements.created_at ASC")}
  after_save :update_medical_record

  belongs_to :user
  belongs_to :trainer, optional: true

  validates :weight,:hips,:chest,:body_fat_percentage,:waist,presence: true
  validates :weight,:hips,:chest,:body_fat_percentage,:waist,numericality: { greater_than_or_equal: 0}

  protected
  def update_medical_record
    medical_record = MedicalRecord.where(user_id: self.user_id).first
    if medical_record
      medical_record.weight = self.weight
      medical_record.chest = self.chest
      medical_record.hips = self.hips
      medical_record.waist = self.waist
      medical_record.body_fat_percentage = self.body_fat_percentage
      medical_record.save
    end
  end
end
