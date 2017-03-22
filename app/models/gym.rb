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

  has_many :branches, -> {reorder("branches.name ASC")}
  has_many :images, as: :imageable, dependent: :destroy
  has_many :offers, dependent: :destroy

  validates :name, :description, :address, :telephone, :email, :birthday, presence: true
  validates :name, :email, :telephone, uniqueness: true
  validates :name, :address, length: {minimum: 3}
  validates_format_of :telephone, :with => /[0-9]{8,10}/x
  validates :description, length: { in: 10...250 }
  validate :validate_speciality

  def self.load_gyms(**args)
    includes(:images,branches: [:users,:trainers,:events])
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.gym_by_id(id)
    includes(:images,branches: [:users,:trainers,:events])
      .find_by_id(id)
  end

  def self.gym_by_email(email)
    includes(:images,branches: [:users,:trainers,:events])
      .find_by_email(email)
  end

  def self.gyms_by_name(name, **args)
    load_gyms(**args)
      .where("gyms.name LIKE ?", "#{name.downcase}")
  end

  def self.gyms_by_speciality(speciality,**args)
    load_gyms(args)
      .where("\'#{speciality}\' = ANY (speciality)")
  end

  def self.gyms_by_ids(ids,**args)
    load_gyms(args)
      .where(gyms:{id: ids})
  end

  def self.gyms_by_not_ids(ids, **args)
    load_gyms(args)
      .where.not(gyms:{id: ids})
  end

  def self.gyms_with_branches(**args)
    joins(:branches).select("gyms.*")
      .select("COUNT(branches.id) AS count_branches")
      .group("gyms.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(branches.id)")
  end

  def self.gyms_with_pictures(**args)
    joins(:images).select("gyms.*")
      .select("COUNT(images.id) AS count_images")
      .group("gyms.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(images.id)")
  end

  def self.gyms_with_offers(**args)
    joins(:offers).select("gyms.*")
      .select("COUNT(offers.id) AS count_offers")
      .group("gyms.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(offers.id)")
  end

  def self.gyms_with_offers_and_date(type,**args)
    joins(:offers).select("gyms.*")
      .where(offers: {
        end_day: Gym.new.set_range(type,args[:year] || 2017,args[:month] || 1)
      })
      .group("gyms.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  protected
  def validate_speciality
    speciality.each do |value|
      errors.add(:speciality,"is not include in the list") unless ["TRX", "crossfit"].include?(value)
    end
  end

end
