class Gym < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User,Utility

  default_scope {order("gyms.name ASC")}
  scope :order_by_id, -> (ord) {order("gyms.id #{ord}")}
  scope :order_by_name, -> (ord) {order("gyms.name #{ord}")}
  scope :order_by_email, -> (ord) {order("gyms.email #{ord}")}
  scope :order_by_birthday, -> (ord) {order("gyms.birthday #{ord}")}
  scope :order_by_created_at, -> (ord) {order("gyms.created_at #{ord}")}

  has_many :branches, -> {reorder("branches.name ASC")}, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :offers, dependent: :destroy

  validates :name, :description, :address, :telephone, :email, :birthday, presence: true
  validates :name, :email, :telephone, uniqueness: true
  validates :name, :address, length: {minimum: 3}
  validates_format_of :telephone, :with => /[0-9]{8,10}/x
  validates :description, length: { in: 10...250 }
  validate :validate_speciality

  def self.load_gyms(page = 1, per_page = 10)
    includes(:images,branches: [:users,:trainers,:events])
      .paginate(:page => page, :per_page => per_page)
  end

  def self.gym_by_id(id)
    includes(:images,branches: [:users,:trainers,:events])
      .find_by_id(id)
  end

  def self.gym_by_email(email)
    includes(:images,branches: [:users,:trainers,:events])
      .find_by_email(email)
  end

  def self.gyms_by_name(name, page = 1, per_page = 10)
    load_gyms(page,per_page)
      .where("gyms.name LIKE ?", "#{name.downcase}")
  end

  def self.gyms_by_speciality(speciality,page = 1, per_page = 10)
    load_gyms(page,per_page)
      .where("\'#{speciality}\' = ANY (speciality)")
  end

  def self.gyms_by_ids(ids,page = 1, per_page = 10)
    load_gyms(page,per_page)
      .where(gyms:{id: ids})
  end

  def self.gyms_by_not_ids(ids, page = 1, per_page = 10)
    load_gyms(page,per_page)
      .where.not(gyms:{id: ids})
  end

  def self.gyms_with_branches(page = 1, per_page = 10)
    joins(:branches).select("gyms.*")
      .select("COUNT(branches.id) AS count_branches")
      .group("gyms.id")
      .paginate(:page => page, :per_page =>per_page)
      .reorder("count(branches.id)")
  end

  def self.gyms_with_pictures(page = 1, per_page = 10)
    joins(:images).select("gyms.*")
      .select("COUNT(images.id) AS count_images")
      .group("gyms.id")
      .paginate(:page => page, :per_page =>per_page)
      .reorder("count(images.id)")
  end

  def self.gyms_with_offers(page = 1, per_page = 10)
    joins(:offers).select("gyms.*")
      .select("COUNT(offers.id) AS count_offers")
      .group("gyms.id")
      .paginate(:page => page,:per_page => per_page)
      .reorder("count(offers.id)")
  end

  def self.gyms_with_offers_and_date(type,page = 1 ,per_page = 10,year = 2017,month = 1)
    joins(:offers).select("gyms.*")
      .where(offers: {
        end_day: Gym.new.set_range(type,year,month)
      })
      .group("gyms.id")
      .paginate(:page => page,:per_page => per_page)
  end

  protected
  def validate_speciality
    speciality.each do |value|
      errors.add(:speciality,"is not include in the list") unless ["TRX", "crossfit"].include?(value)
    end
  end

end
