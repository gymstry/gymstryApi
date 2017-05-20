class Api::V1::UserSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :lastname, if: :render_lastname?
  attribute :username, if: :render_username?
  attribute :avatar, if: :render_avatar?
  attribute :email, if: :render_email?
  attribute :mobile, if: :render_mobile?
  attribute :remaining_days, if: :render_remaining_days?
  attribute :birthday, if: :render_birthday?
  attribute :gender, if: :render_gender?
  attribute :objective, if: :render_objective?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"users.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"users.name","name")
  end

  def render_lastname?
    render?(instance_options[:render_attribute].split(","),"users.lastname","lastname")
  end

  def render_username?
    render?(instance_options[:render_attribute].split(","),"users.username","username")
  end

  def render_avatar?
    render?(instance_options[:render_attribute].split(","),"users.avatar","avatar")
  end

  def render_email?
    render?(instance_options[:render_attribute].split(","),"users.email","email")
  end

  def render_mobile?
    render?(instance_options[:render_attribute].split(","),"users.mobile","mobile")
  end

  def render_remaining_days?
    render?(instance_options[:render_attribute].split(","),"users.remaining_days","remaining_days")
  end

  def render_birthday?
    render?(instance_options[:render_attribute].split(","),"users.birthday","birthday")
  end

  def render_gender?
    render?(instance_options[:render_attribute].split(","),"users.gender","gender")
  end

  def render_objective?
    render?(instance_options[:render_attribute].split(","),"users.objective","objective")
  end

end
