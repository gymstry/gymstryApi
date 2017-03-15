class Timetable < ApplicationRecord

  default_scope {order("timetables.day ASC")}
  scope :order_by_day, -> (ord) {order("timetables.day #{ord}")}
  scope :order_by_open_hour, -> (ord) {order("timetables.open_hour  #{ord}")}
  scope :order_by_close_hour, -> (ord) {order("timetables.close_hour #{ord}")}
  scope :search_by_branch_id, -> (id) {where(timetables: {branch_id: id})}

  belongs_to :branch

  validates :day,:open_hour,:close_hour,presence: true
  validate :open_greater_close
  validate :valid_day


  def self.load_timetables(page = 1, per_page = 10)
    includes(branch: [:user,:trainers,:events])
      .paginate(:page => page,:per_page => per_page)
  end

  def self.timetable_by_id(id)
    includes(branch: [:user,:trainers,:events])
      .find_by_id(id)
  end

  def self.timetables_by_ids(ids,page = 1, per_page = 10)
    load_timetables(page,per_page)
      .where(timetables:{id: ids})
  end

  def self.timetables_by_not_ids(ids,page = 1, per_page = 10)
    load_timetables(page,per_page)
      .where.not(timetables:{id:ids})
  end

  def self.timetables_by_branch_id(id,page = 1, per_page = 10)
    load_timetables(page,per_page)
      .search_by_branch_id(id)
  end

  def self.timetables_by_open_hour(hour,page = 1, per_page = 10)
    load_timetables(page,per_page)
      .where(timetables:{open_hour: hour})
  end

  def self.timetables_by_close_hour(hour,page = 1, per_page = 10)
    load_timetables(page,per_page)
      .where(timetables:{close_hour: hour})
  end

  def self.timetables_by_day(day,page = 1, per_page = 10)
    load_timetables(page, per_page)
      .where(timetables:{day: day})
  end

  def self.timetable_by_day_and_branch_id(day,id)
    includes(branch: [:user,:trainers,:events])
      .find_by_id_and_day(id,day)
  end

  protected
  def open_greater_close
    if open_hour && close_hour && open_hour >= close_hour
      errors.add(:open_hour, "can't be greater than close hour")
      errors.add(:close_hour, "can't be less than open_hour")
    end
  end

  def valid_day
    if day && day < Date.today
      errors.add(:day, "can't be in the past")
    end
  end
end
