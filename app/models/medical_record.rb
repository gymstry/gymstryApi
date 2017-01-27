class MedicalRecord < ApplicationRecord

  default_scope {order("medical_records.created_at  ASC")}
  scope :order_by_weight, -> (ord) {order("medical_records.weight #{ord}")}
  scope :order_by_chest, -> (ord) {order("medical_records.chest #{ord}")}
  scope :order_by_hips, -> (ord) {order("medical_records.waist #{ord}")}
  scope :order_by_body_fat_percentage, -> (ord) {order("medical_records.body_fat_percentage #{ord}")}
  scope :order_by_updated_at, -> (ord) {order("medical_records.updated_at #{ord}")}

  belongs_to :user
  has_many :medical_record_by_disease, dependent: :destroy
  has_many :diseases, -> {(reorder("diseases.name ASC"))}, through: :medical_record_by_disease
  has_many :prohibited_exercises, dependent: :destroy
  has_many :exercises, -> {(reorder("exercises.name ASC"))}, through: :prohibited_exercises

  validates :weight,:chest,:hips,:waist,:body_fat_percentage,presence: true
  validates :weight,:chest,:hips,:waist,:body_fat_percentage,numericality: { greater_than_or_equal: 0 }

  def self.load_medical_records(page = 1, per_page = 10)
    includes(:diseases,exercises: [:images], user: [:challanges,:workouts,:measurements])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.medical_record_by_id(id)
    includes(:diseases,exercises: [:images], user: [:challanges,:workouts,:measurements])
      .find_by_id(id)
  end

  def self.medical_records_by_ids(ids, page = 1, per_page = 10)
    load_medical_records(page,per_page)
      .where(id: ids)
  end

  def self.medical_records_by_not_ids(ids, page = 1, per_page = 10)
    load_medical_records(page,per_page)
      .where.not(id: ids)
  end

  def self.medical_record_by_user(user)
    includes(:diseases,exercises: [:images], user: [:challanges,:workouts,:measurements])
      .where(medical_records: {user_id: user})
  end

  def self.medical_records_with_diseases(page = 1, per_page = 10)
    joins(:medical_record_by_disease).select("medical_records.*")
      .group("medical_records.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(medical_record_by_disease.id)")
  end

  def self.medical_records_with_exercises(page = 1, per_page = 10)
    joins(:prohibited_exercises).select("medical_records.*")
      .group("medical_records.id")
      .paginate(:page => page, :per_page => per_page)
      .reorder("count(prohibited_exercises.id)")
  end

end
