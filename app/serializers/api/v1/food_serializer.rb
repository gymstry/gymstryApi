class Api::V1::FoodSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :description, if: :render_description?
  attribute :proteins, if: :render_proteins?
  attribute :carbohydrates, if: :render_carbohydrates?
  attribute :fats, if: :render_fats?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"foods.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"foods.name","name")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"foods.description","description")
  end

  def render_proteins?
    render?(instance_options[:render_attribute].split(","),"foods.proteins","proteins")
  end

  def render_carbohydrates?
    render?(instance_options[:render_attribute].split(","),"foods.carbohydrates","carbohydrates")
  end

  def render_fats?
    render?(instance_options[:render_attribute].split(","),"foods.fats","fats")
  end

end
