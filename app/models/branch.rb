class Branch < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  belongs_to :gym
  has_many :users, -> {reorder("users.name ASC, users.lastname ASC ")}, dependent: :destroy
  has_many :trainers, -> {reorder("trainers.name ASC, trainers.lastname ASC")}, dependent: :nullify

  validates :name, :email, :address, :telephone, presence: true
  validates :name, length: {minimum: 3}
  validates :email, uniqueness: true
  validates_format_of :telephone, :with => /[0-9]{8,10}/x
  validates :address, length: {minimum: 3}

end
