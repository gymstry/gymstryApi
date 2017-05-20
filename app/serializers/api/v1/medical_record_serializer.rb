class Api::V1::MedicalRecordSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :observation, if: :render_observation?
  attribute :weight,if: :render_weight?
  attribute :medication,if: :render_medication?
  attribute :body_fat_percentage,if: :render_body_fat_percentage?
  attribute :waist, if: :render_waist?
  attribute :hips, if: :render_hips?
  attribute :chest, if: :render_chest?

  def render_id?
    render?(instance_options[:render_attribute].split(","),"medical_records.id","id")
  end

  def render_observation?
    render?(instance_options[:render_attribute].split(","),"medical_records.observation","observation")
  end

  def render_weight?
    render?(instance_options[:render_attribute].split(","),"medical_records.weight","weight")
  end

  def render_medication?
    render?(instance_options[:render_attribute].split(","),"medical_records.medication","medication")
  end

  def render_body_fat_percentage?
    render?(instance_options[:render_attribute].split(","),"medical_records.body_fat_percentage","body_fat_percentage")
  end

  def render_waist?
    render?(instance_options[:render_attribute].split(","),"medical_records.waist","waist")
  end

  def render_hips?
    render?(instance_options[:render_attribute].split(","),"medical_records.hips","hips")
  end

  def render_chest?
    render?(instance_options[:render_attribute].split(","),"medical_records.chest","chest")
  end

end
