class Gym < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :branches, -> {reorder("branches.name ASC")}, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy

  validates :name, :description, :address, :telephone, :email, :speciality, :birthday, presence: true
  validates :name, :email, :telephone, uniqueness: true
  validates :name, :speciality, length: {minimum: 3}
  validates_format_of :telephone, :with => /[0-9]{8,10}/x
  validates :description, length: { in: 10...250 }
  validates :address, length: {minimum: 3}

end
