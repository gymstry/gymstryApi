class Image < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope {order("images.created_at ASC")}
  scope :order_by_created_at, -> (ord) {order("images.created_at #{ord}")}

  belongs_to :imageable, polymorphic: true

  validates_integrity_of :image
  validates_processing_of :image
  validates :image, file_size: { less_than_or_equal_to: 1.megabyte }

  def self.load_images(page = 1, per_page = 10)
    includes(:imageable)
      .paginate(:page => page, :per_page => per_page)
  end

  def self.image_by_id(id)
    includes(:imageable)
      .find_by_id(id)
  end

  def self.images_by_ids(ids,page = 1, per_page = 10)
    load_images(page,per_page)
      .where(images:{id: ids})
  end

  def self.images_by_not_ids(ids, page = 1, per_page = 10)
    load_images(page,per_page)
      .where.not(images:{id: ids})
  end

end
