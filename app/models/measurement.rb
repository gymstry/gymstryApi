class Measurement < ApplicationRecord
  include Utility

  default_scope {order("measurements.created_at ASC")}
  scope :order_by_weight, -> (ord) {order("measurements.weight #{ord}")}
  scope :order_by_hips, -> (ord) {order("measurements.hips #{ord}")}
  scope :order_by_chest, -> (ord) {order("measurements.chest #{ord}")}
  scope :order_by_body_fat_percentage, -> (ord) {order("measurements.body_fat_percentage #{ord}")}
  scope :order_by_created_at, -> (ord) {order("measurements.created_at #{ord}")}
  scope :search_by_trainer_id, -> (id) {where(measurements:{trainer_id:id})}
  scope :search_by_user_id, -> (id) {where(measurements:{user_id:id})}
  after_save :update_medical_record

  belongs_to :user
  belongs_to :trainer, optional: true

  validates :weight,:hips,:chest,:body_fat_percentage,:waist,presence: true
  validates :weight,:hips,:chest,:body_fat_percentage,:waist,numericality: { greater_than_or_equal: 0}

  def self.load_measurements(**args)
    includes(user: [:medical_record,:challanges,:workouts],trainer: [:challanges,:qualifications,:workouts])
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.measurement_by_id(id)
    includes(user: [:medical_record,:challanges,:workouts],trainer: [:challanges,:qualifications,:workouts])
      .find_by_id(id)
  end

  def self.measurements_by_ids(ids,**args)
    load_measurements(args)
      .where(measurements:{
        id: ids
      })
  end

  def self_measurements_by_not_ids(ids,**args)
    load_measurements(args)
      .where.not(measurements:{
        id: ids
      })
  end

  def self.measurements_by_trainer(trainer, **args)
    load_measurements(args).search_by_trainer_id(trainer)
  end

  def self.measurements_by_user(user, **args)
    load_measurements(args).search_by_user_id(user)
  end

  def self.measurements_by_date(type,**args)
    load_measurements({page: args[:page],per_page: args[:per_page]})
      .where(measurements:{
        created_at: Measurement.new.set_range(type,args[:year] || 2017,args[:month] || 1)
      })
  end

  def self.measurements_by_date_and_user(user,**args)
    load_measurements({page: args[:page],per_page: args[:per_page]})
      .where(measurements:{
        created_at: Measurement.new.set_range(args[:type],args[:year] || 2017,args[:month] || 1)
      })
      .search_by_user_id(user)
  end

  def self.measurements_by_data_and_trainer(trainer,**args)
    load_measurements({page: args[:page],per_page: args[:per_page]})
      .where(measurements:{
        created_at: Measurement.new.set_range(args[:type],args[:year] || 2017,args[:month] || 1)
      })
      .search_by_trainer_id(trainer)
  end

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
