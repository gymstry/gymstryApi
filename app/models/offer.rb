class Offer < ApplicationRecord

  default_scope {order("offers.name ASC")}
  scope :order_by_name, -> (ord) {order("offers.name #{ord}")}
  scope :order_by_start_day, -> (ord) {order("offers.start_day #{ord}")}
  scope :order_by_end_day, -> (ord) {order("offers.end_day #{ord}")}
  scope :serarch_by_gym_id, -> (id) {where(offers:{gym_id: id})}

  belongs_to :gym

  validates :name,:start_day,:end_day,presence: true
  validates :name,length:{minimum: 3}
  validate :start_greater_end

  def self.load_offers(page = 1, per_page = 10)
    includes(gym: [:branches])
      .paginate(:page => page,:per_page => per_page)
  end

  def self.offer_by_id(id)
    includes(gym: [:branches])
      .find_by_id(id)
  end

  def self.offers_by_ids(ids,page = 1, per_page = 10)
    load_offers(page, per_page)
      .where(offers:{id: ids})
  end

  def self.offers_by_not_ids(ids,page = 1,per_page = 10)
    load_offers(page,per_page)
      .where.not(offers:{id: ids})
  end

  def self.offers_by_gym_id(id,page = 1,per_page = 10)
    load_offers(page,per_page)
      .serarch_by_gym_id(id)
  end

  def self.offers_by_start_day(date,page = 1, per_page = 10)
    load_offers(page,per_page)
      .where(offers:{start_day: date})
  end

  def self.offers_by_start_day_and_gym(date,id,page = 1,per_page = 10)
    offers_by_start_day(date,page,per_page)
      .serarch_by_gym_id(id)
  end

  def self.offers_by_end_day(date,page = 1 per_page = 10)
    load_offers(page = 1,per_page = 10)
      .where(offers:{end_day: date})
  end

  def self.offers_by_end_day_and_gym(date,id,page = 1, per_page = 10)
    offers_by_end_day(date,page,per_page)
      .serarch_by_gym_id(id)
  end

  protected
  def start_greater_end
    if start_day && end_day && start_day > end_day
      errors.add(:start_day,"can't be greater than end day")
      errors.add(:end_day, "can't be less than start day")
    end
  end

end
