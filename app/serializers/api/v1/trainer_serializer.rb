class Api::V1::TrainerSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :lastname, if: :render_lastname?
  attribute :mobile, if: :render_mobile?
  attribute :email, if: :render_email?
  attribute :speciality, if: :render_speciality?
  attribute :type_trainer, if: :render_type_trainer?
  attribute :avatar, if: :render_avatar?
  attribute :birthday, if: :render_birthday?
  attribute :username, if: :render_username?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"trainers.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"trainers.name","name")
  end

  def render_lastname?
    render?(instance_options[:render_attribute].split(","),"trainers.lastname","lastname")
  end

  def render_mobile?
    render?(instance_options[:render_attribute].split(","),"trainers.mobile","mobile")
  end

  def render_email?
    render?(instance_options[:render_attribute].split(","),"trainers.email","email")
  end

  def render_speciality?
    render?(instance_options[:render_attribute].split(","),"trainers.speciality","speciality")
  end

  def render_type_trainer?
    render?(instance_options[:render_attribute].split(","),"trainers.type_trainer","typer_trainer")
  end

  def render_avatar?
    render?(instance_options[:render_attribute].split(","),"trainers.avatar","avatar")
  end

  def render_birthday?
    render?(instance_options[:render_attribute].split(","),"trainers.birthday","birthday")
  end

  def render_username?
    render?(instance_options[:render_attribute].split(","),"trainers.username","username")
  end

end
