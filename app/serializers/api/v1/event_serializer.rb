class Api::V1::EventSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :description, if: :render_description?
  attribute :name, if: :render_name?
  attribute :otro_name, if: :render_otro_name?
  attribute :class_date, if: :render_class_date?
  attribute :duration, if: :render_duration?
  attribute :type_event, if: :render_type_event?
  attribute :image, if: :render_image?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"events.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"events.name","name")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"events.description","description")
  end

  def render_otro_name?
    render?(instance_options[:render_attribute].split(","),"events.otro_name","otro_name")
  end

  def render_class_date?
    render?(instance_options[:render_attribute].split(","),"events.class_date","class_date")
  end

  def render_duration?
    render?(instance_options[:render_attribute].split(","),"admins.duration","duration")
  end

  def render_type_event?
    render?(instance_options[:render_attribute].split(","),"events.type_event","type_event")
  end

  def render_image?
    render?(instance_options[:render_attribute].split(","),"events.image","image")
  end
end
