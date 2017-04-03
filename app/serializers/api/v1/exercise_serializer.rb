class Api::V1::ExerciseSerializer < ActiveModel::Serializer
  include SerializerAttribute
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :description, if: :render_description?
  attribute :problems, if: :render_problems?
  attribute :benefits, if: :render_benefits?
  attribute :muscle_group, if: :render_muscle_group?
  attribute :elements, if: :render_elements?
  attribute :owner, if: :render_owner?
  attribute :level, if: :render_level?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"exercises.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"exercises.name","name")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"exercises.description","description")
  end

  def render_problems?
    render?(instance_options[:render_attribute].split(","),"exercises.problems","problems")
  end

  def render_benefits?
    render?(instance_options[:render_attribute].split(","),"exercises.benefits","benefits")
  end

  def render_muscle_group?
    render?(instance_options[:render_attribute].split(","),"exercises.muscle_group","muscle_group")
  end

  def render_elements?
    render?(instance_options[:render_attribute].split(","),"exercises.elements","elements")
  end

  def render_owner?
    render?(instance_options[:render_attribute].split(","),"exercises.owner","owner")
  end

  def render_level?
    render?(instance_options[:render_attribute].split(","),"exercises.level","level")
  end
end
