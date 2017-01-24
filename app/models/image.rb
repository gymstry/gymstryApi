class Image < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope {order("images.created_at ASC")}

  belongs_to :imageable, polymorphic: true

  validates_integrity_of :image
  validates_processing_of :image
  validates :image, file_size: { less_than_or_equal_to: 1.megabyte }


end
