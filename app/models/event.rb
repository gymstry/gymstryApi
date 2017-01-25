class Event < ApplicationRecord
  include Utility
  mount_uploader :image, ImageUploader
  default_scope {order("events.name ASC")}
  scope :order_by_id, -> (ord) {order("events.id #{ord}")}
  scope :order_by_name, -> (ord) {order("events.name #{ord}")}
  scope :order_by_class_date, -> (ord) {order("events.class_date #{ord}")}
  scope :order_by_created_at, -> (ord) {order("events.created_at #{ord}")}
  scope :order_by_type, -> (ord) {order("events.type_event #{ord}")}
  scope :search_by_branch_id, -> (id) {where(events:{branch_id: id})}

  belongs_to :branch

  #We need to talk with the gym and add more common classes
  enum type_event: {
    :TXR => 0,
    :yoga => 1,
    :force => 2,
    :other => 3
  }

  validates :name, :class_date, :type, presence: true
  validates :name, length: {minimum: 3}
  validates :type_event, inclusion: {in: type_events.keys}
  validate :valid_date
  validates_integrity_of :image
  validates_processing_of :image
  validates :image, file_size: { less_than_or_equal_to: 1.megabyte }

  def self.load_events(page = 1, per_page = 10)
    includes(branch: [:gym])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.event_by_id(id)
    includes(branch: [:gym])
      .find_by_id(id)
  end

  def self.events_by_name(name,page = 1, per_page = 10)
    load_events(page,per_page)
      .where("events.name LIKE ?", "#{name.downcase}%")
  end

  def self.events_by_ids(ids, page = 1, per_page = 10)
    load_events(page,per_page)
      .where(events:{id: ids})
  end

  def self.events_by_not_ids(ids, page = 1, per_page = 10)
    load_events(page,per_page)
      .where.not(events:{id: ids})
  end

  def self.events_by_date(type,page = 1, per_page = 10,year = 2017, month = 1)
    load_events(page,per_page)
      .where(events:{class_date: Event.new.set_range(type,year,month)})
  end

  def self.events_by_date_and_branch(type,branch,page = 1 ,per_page = 10, year = 2017, month = 1)
    events_by_date(type,page,per_page,year,month)
      .search_by_branch_id(branch)
  end

  protected
  def valid_date
    if class_date && class_date < Date.today
      errors.add(:class_date,"can't be in the past")
    end
  end


end
