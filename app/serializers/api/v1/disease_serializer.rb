class Api::V1::DiseaseSerializer < ActiveModel::Serializer
  include SerializerAttribute
  attribute :id, if: :render_id?
  attribute :description, if: :render_description?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"diseases.id","id")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"diseases.description","description")
  end
end
