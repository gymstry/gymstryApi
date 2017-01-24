class Food < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope {order("foods.name ASC")}

  belongs_to :food_day, optional: true

  validates :name, :proteins,:carbohydrates,:fats, presence: true
  validates :name, uniqueness: true
  validates :name, length: {minimum: 3}
  validates :proteins,:carbohydrates,:fats,numericality: { greater_than_or_equal: 0 }
  validates_integrity_of :image
  validates_processing_of :image
  validates :image, file_size: { less_than_or_equal_to: 1.megabyte }


end
