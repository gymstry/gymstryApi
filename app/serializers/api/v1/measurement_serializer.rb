class Api::V1::MeasurementSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :weight, if: :render_weight?
  attribute :hips, if: :render_hips?
  attribute :chest, if: :render_chest?
  attribute :body_fat_percentage, if: :render_body_fat_percentage?
  attribute :waist, if: :render_waist?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"measurements.id","id")
  end

  def render_weight?
    render?(instance_options[:render_attribute].split(","),"measurements.weight","weight")
  end

  def render_hips?
    render?(instance_options[:render_attribute].split(","),"measurements.hips","hips")
  end

  def render_chest?
    render?(instance_options[:render_attribute].split(","),"measurements.chest","chest")
  end

  def render_body_fat_percentage?
    render?(instance_options[:render_attribute].split(","),"measurements.body_fat_percentage","body_fat_percentage")
  end

  def render_waist?
    render?(instance_options[:render_attribute].split(","),"measurments.waist","waist")
  end

end
