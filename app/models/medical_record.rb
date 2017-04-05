class MedicalRecord < ApplicationRecord

  default_scope {order("medical_records.created_at  ASC")}
  scope :order_by_weight, -> (ord) {order("medical_records.weight #{ord}")}
  scope :order_by_chest, -> (ord) {order("medical_records.chest #{ord}")}
  scope :order_by_hips, -> (ord) {order("medical_records.waist #{ord}")}
  scope :order_by_body_fat_percentage, -> (ord) {order("medical_records.body_fat_percentage #{ord}")}
  scope :order_by_updated_at, -> (ord) {order("medical_records.updated_at #{ord}")}
  scope :search_by_user, -> (id) {where("medical_records.user_id = ?", id)}

  belongs_to :user
  has_many :medical_record_by_diseases
  has_many :diseases, -> {(reorder("diseases.name ASC"))}, through: :medical_record_by_diseases
  has_many :prohibited_exercises
  has_many :exercises, -> {(reorder("exercises.name ASC"))}, through: :prohibited_exercises

  validates :weight,:chest,:hips,:waist,:body_fat_percentage,presence: true
  validates :weight,:chest,:hips,:waist,:body_fat_percentage,numericality: { greater_than_or_equal: 0 }

  def self.load_medical_records(**args)
    params = (args[:medical_record_params] || "medical_records.*") + ","
    params = params + "medical_records.id,medical_records.user_id"
    includes(:diseases,exercises: [:images], user: [:challanges,:workouts,:measurements,:branch])
      .select(params)
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.medical_record_by_id(id,**args)
    params = (args[:medical_record_params] || "medical_records.*") + ","
    params = params + "medical_records.id,medical_records.user_id,medical_records.updated_at"
    includes(:diseases,exercises: [:images], user: [:challanges,:workouts,:measurements,:branch])
      .select(params)
      .find_by_id(id)
  end

  def self.medical_records_by_ids(ids, **args)
    load_medical_records(args)
      .where(id: ids)
  end

  def self.medical_records_by_not_ids(ids, **args)
    load_medical_records(args)
      .where.not(id: ids)
  end

  def self.medical_record_by_user(user,**args)
    load_medical_records(args)
      .where(medical_records: {user_id: user}).first
  end

  def self.medical_records_with_diseases(**args)
    joins(:medical_record_by_diseases).select(args[:medical_record_params] || "medical_records.*")
      .group("medical_records.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(medical_record_by_diseases.id)")
  end

  def self.medical_records_with_exercises(**args)
    joins(:prohibited_exercises).select(args[:medical_record_params] || "medical_records.*")
      .group("medical_records.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(prohibited_exercises.id)")
  end

end
