class Qualification < ApplicationRecord
  mount_uploader :qualification, QualificationUploader


  default_scope {order("qualifications.name ASC")}

  belongs_to :trainer

  validates :name, presence: true
  validates :name, length: {minimum: 3}
  validates_integrity_of :qualification
  validates_processing_of :qualification
  validates :qualification, file_size: { less_than_or_equal_to: 1.megabyte }


end
