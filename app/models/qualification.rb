class Qualification < ApplicationRecord

  default_scope {order("qualifications.name ASC")}

  belongs_to :trainer

  validates :name,:qualification, presence: true
  validates :name, length: {minimum: 3}
  
end
