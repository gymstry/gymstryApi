class Api::V1::FoodDaySerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :type_food, if: :render_type_food?
  attribute :description, if: :render_description?
  attribute :benefits, if: :render_benefits?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"food_days.id","id")
  end

  def render_type_food?
    render?(instance_options[:render_attribute].split(","),"food_days.type_food","type_food")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"food_days.description","description")
  end

  def render_benefits?
    render?(instance_options[:render_attribute],"food_days.benefits","benefits")
  end

end
