class Image < ApplicationRecord

  default_scope {order("images.created_at ASC")}

  belongs_to :imageable, polymorphic: true

  validates :image, presence: true
  
end
