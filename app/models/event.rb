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
    :TRX => 0,
    :yoga => 1,
    :force => 2,
    :other => 3
  }

  validates :name, :class_date, :type_event, presence: true
  validates :name, length: {minimum: 3}
  validates :type_event, inclusion: {in: type_events.keys}
  validate :valid_date
  validates_integrity_of :image
  validates_processing_of :image
  validates :image, file_size: { less_than_or_equal_to: 1.megabyte }

  def self.load_events(**args)
    params = (args[:event_params] || "events.*") + ","
    params = params + "events.id,events.branch_id"
    includes(branch: [:gym])
      .select(params)
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.event_by_id(id,**args)
    params = (args[:event_params] || "events.*") + ","
    params = params + "events.id,events.branch_id,events.updated_at"
    includes(branch: [:gym])
      .select(params)
      .find_by_id(id)
  end

  def self.events_by_search(name,**args)
    load_events(args)
      .where("events.name LIKE ?", "#{name.downcase}%")
  end

  def self.events_by_ids(ids, **args)
    load_events(args)
      .where(events:{id: ids})
  end

  def self.events_by_not_ids(ids, **args)
    load_events(args)
      .where.not(events:{id: ids})
  end

  def self.events_by_date(type = "today",**args)
    load_events({page: args[:page], per_page: args[:per_page]})
      .where(events:{
        class_date: Event.new.set_range(type || "today",args[:year] || Date.today.year,args[:month] || 1)
      })
  end

  def self.events_by_date_and_branch(type = "today",**args)
    events_by_date(type,{page:args[:page],per_page:args[:per_page],year: args[:year],month: args[:month]})
      .search_by_branch_id(args[:branch])
  end

  def self.events_by_type_event(type_event = "TRX",**args)
    events = load_events(**args)
    case (type_event || "other").downcase
    when "TRX"
      events = events.TRX
    when "force"
      events = events.force
    when "yoga"
      events = events.yoga
    when "other"
      events = events.other
    else
      events = events.other
    end
    events
  end

  def self.events_by_type_event_date(type_event,**args)
    events_by_type_event(type_event,{page: args[:page],per_page: args[:per_page]})
      .events_by_date({type: args[:type],year: args[:year],month: args[:month],page: args[:page],per_page: args[:per_page]})
  end

  protected
  def valid_date
    if !class_date && class_date < Date.today
      errors.add(:class_date,"can't be in the past")
    end
  end


end
