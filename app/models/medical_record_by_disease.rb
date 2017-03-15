class MedicalRecordByDisease < ApplicationRecord
  belongs_to :medical_record
  belongs_to :disease
end
