class Disease < ApplicationRecord
  has_many :medical_record_by_disease, dependent: :destroy
  has_many :medical_records, through: :medical_record_by_disease
end
