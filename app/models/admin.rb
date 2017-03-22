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

  def self.load_admins(**args)
    paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.admin_by_id(id)
    find_by_id(id)
  end

  def self.admins_by_ids(ids,**args)
    load_admins(args)
      .where(admins:{id: ids})
  end

  def self.admins_by_not_ids(ids,**args)
    load_admins(args)
      .where.not(admins:{id: ids})
  end

  def self.admin_by_email(email)
    find_by_email(email)
  end

  def self.admin_by_username(username)
    find_by_username(username)
  end

  def self.admin_by_name(name,**args)
    load_admins(args)
      .where("admins.name LIKE ?", "#{name.downcase}%")
  end
end
