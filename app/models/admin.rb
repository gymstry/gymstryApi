class Admin < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  default_scope {order("admins.name ASC")}
  scope :order_by_name, -> (ord) {order("admins.name #{ord}")}
  scope :order_by_email, -> (ord) {order("admins.email #{ord}")}
  scope :order_by_username, -> (ord) {order("admins.username #{ord}")}

  validates :name,:email,:username, presence: true
  validates :name, length: {minimum: 3}
  validates :username, length: {minimum: 5}
  validates :email,:username, uniqueness: true

  def self.load_admins(page = 1, per_page = 10)
    paginate(:page => page, :per_page => per_page)
  end

  def self.admin_by_id(id)
    find_by_id(id)
  end

  def self.admins_by_ids(ids,page = 1,per_page = 10)
    load_admins(page,per_page)
      .where(admins:{id: ids})
  end

  def self.admins_by_not_ids(ids,page = 1, per_page = 10)
    load_admins(page,per_page)
      .where.not(admins:{id: ids})
  end

  def self.admin_by_email(email)
    find_by_email(email)
  end

  def self.admin_by_username(username)
    find_by_username(username)
  end

  def self.admin_by_name(name,page = 1, per_page = 10)
    load_admins(page,per_page)
      .where("admins.name LIKE ?", "#{name.downcase}%")
  end
end
