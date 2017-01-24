class Event < ApplicationRecord

  default_scope {order("events.name ASC")}

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

  protected
  def valid_date
    if class_date && class_date < Date.today
      errors.add(:class_date,"can't be in the past")
    end
  end
end
