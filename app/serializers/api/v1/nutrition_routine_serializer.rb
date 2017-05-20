class Api::V1::NutritionRoutineSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :description, if: :render_description?
  attribute :objective, if: :render_objective?
  attribute :start_date, if: :render_start_date?
  attribute :end_date, if: :render_end_date?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"nutrition_routines.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"nutrition_routines.name","name")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"nutrition_routines.description","description")
  end

  def render_objective?
    render?(instance_options[:render_attribute].split(","),"nutrition_routines.objective","objective")
  end

  def render_start_date?
    render?(instance_options[:render_attribute].split(","),"nutrition_routines.start_date","start_date")
  end

  def render_end_date?
    render?(instance_options[:render_attribute].split(","),"nutrition_routines.end_date","end_date")
  end

end
