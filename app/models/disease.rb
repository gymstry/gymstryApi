class Disease < ApplicationRecord

  default_scope {order("diseases.name ASC")}

  has_many :medical_record_by_disease, dependent: :destroy
  has_many :medical_records, through: :medical_record_by_disease

  validates :name,:description, presence: true
  validates :name, length: {minimum: 3}
  validates :description, length: { in: 10...250 }

end
