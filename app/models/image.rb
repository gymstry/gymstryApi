class Image < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope {order("images.created_at ASC")}
  scope :order_by_created_at, -> (ord) {order("images.created_at #{ord}")}
  scope :search_by_imageble_type, -> (type) {where(images:{
      imageable_type: type
  })}
  belongs_to :imageable, polymorphic: true

  validates_integrity_of :image
  validates_processing_of :image
  validates :image, file_size: { less_than_or_equal_to: 1.megabyte }

  def self.load_images(**args)
    params = (args[:image_params] || "images.*") + ","
    params = params + "images.id"
    includes(:imageable)
      .select(params)
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.images_by_gym(gym,**args)
    load_images(args)
      .search_by_imageble_type("Gym")
        .where(images: {
            imageable_id: gym
        })
  end

  def self.images_by_exercise(exercise,**args)
    load_images(args)
      .search_by_imageble_type("Exercise")
        .where(images: {
            imageable_id: gym
        })
  end

  def self.image_by_id(id,**args)
    params = (args[:image_params] || "images.*") + ","
    params = params + "images.id"
    includes(:imageable)
      .select(params)
      .find_by_id(id)
  end

  def self.images_by_ids(ids,**args)
    load_images(args)
      .where(images:{id: ids})
  end

  def self.images_by_not_ids(ids,**args)
    load_images(args)
      .where.not(images:{id: ids})
  end

end
