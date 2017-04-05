class Api::V1::GymSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :description, if: :render_description?
  attribute :address, if: :render_address?
  attribute :telephone, if: :render_telephone?
  attribute :speciality, if: :render_speciality?
  attribute :email, if: :render_email?
  attribute :birthday, if: :render_birthday?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"gyms.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"gyms.name","name")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"gyms.description","description")
  end

  def render_address?
    render?(instance_options[:render_attribute].split(","),"gyms.address","address")
  end

  def render_telephone?
    render?(instance_options[:render_attribute].split(","),"gyms.telephone","telephone")
  end

  def render_speciality?
    render?(instance_options[:render_attribute].split(","),"gyms.speciality","speciality")
  end

  def render_email?
    render?(instance_options[:render_attribute].split(","),"gyms.email","email")
  end

  def render_birthday?
    render?(instance_options[:render_attribute].split(","),"gyms.birthday","birthday")
  end

end
