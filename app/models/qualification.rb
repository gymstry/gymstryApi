class Qualification < ApplicationRecord
  mount_uploader :qualification, QualificationUploader

  default_scope {order("qualifications.name ASC")}
  scope :order_by_name, -> (ord) {order("qualifications.name #{ord}")}
  scope :order_by_created_at, -> (ord) {order("qualifications.created_at #{ord}")}
  scope :search_by_trainer_id, -> (id) {where(qualifications: {trainer_id: id})}

  belongs_to :trainer

  validates :name, presence: true
  validates :name, length: {minimum: 3}
  validates_integrity_of :qualification
  validates_processing_of :qualification
  validates :qualification, file_size: { less_than_or_equal_to: 1.megabyte }

  def self.load_qualifications(page = 1,per_page = 10)
    includes(trainer: [:challanges,:workouts])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.qualification_by_id(id)
    includes(trainer: [:challanges,:workouts])
      .find_by_id(id)
  end

  def self.qualifications_by_name(name,page = 1,per_page = 10)
    load_qualifications(page,per_page)
      .where("qualifications.name LIKE ?", "#{name.downcase}%")
  end

  def self.qualifications_by_ids(ids, page = 1, per_page = 10)
    load_qualifications(page,per_page)
      .where(qualifications: {id: ids})
  end

  def self.qualifications_by_not_ids(ids,page = 1, per_page = 10)
    load_qualifications(page,per_page)
      .where.not(qualifications:{id: ids})
  end

  def self.qualifications_by_trainer_id(trainer,page = 1, per_page = 10)
    load_qualifications(page,per_page)
      .search_by_trainer_id(trainer)
  end

end
