class Api::V1::BranchSerializer < ActiveModel::Serializer
  include SerializerAttribute
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :email, if: :render_email?
  attribute :address, if: :render_address?
  attribute :telephone, if: :render_telephone?
  attribute :uid, if: :render_uid?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"branches.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"branches.name","name")
  end

  def render_email?
    render?(instance_options[:render_attribute].split(","),"branches.email","email")
  end

  def render_address?
    render?(instance_options[:render_attribute].split(","),"branches.address","address")
  end

  def render_telephone?
    render?(instance_options[:render_attribute].split(","),"branches.telephone","telephone")
  end

  def render_uid?
    render?(instance_options[:render_attribute].split(","),"branches.uid","uid")
  end

end
