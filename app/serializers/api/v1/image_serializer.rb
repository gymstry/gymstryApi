class Api::V1::ImageSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :description, if: :render_description?
  attribute :image, if: :render_image?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"images.id","id")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"images.description","description")
  end

  def render_image?
    render?(instance_options[:render_attribute].split(","),"images.image","image")
  end

end
