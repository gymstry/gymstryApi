class Api::V1::AdminSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :email, if: :render_email?
  attribute :username, if: :render_username?
  attribute :uid, if: :render_uid?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"admins.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"admins.name","name")
  end

  def render_email?
    render?(instance_options[:render_attribute].split(","),"admins.email","email")
  end

  def render_username?
    render?(instance_options[:render_attribute].split(","),"admins.username","username")
  end

  def render_uid?
    render?(instance_options[:render_attribute].split(","),"admins.uid","uid")
  end


end
