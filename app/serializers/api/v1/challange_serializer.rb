class Api::V1::ChallangeSerializer < ActiveModel::Serializer
  include SerializerAttribute
  type 'data'
  attribute :id, if: :render_id?
  attribute :name, if: :render_name?
  attribute :description, if: :render_name?
  attribute :type_challange, if: :render_type_challange?
  attribute :strart_date, if: :render_start_date?
  attribute :end_date, if: :render_end_date?
  attribute :state, if: :render_state?
  attribute :objective, if: :render_objective

  def render_id?
    render?(instance_options[:render_attribute].split(","),"challanges.id","id")
  end

  def render_name?
    render?(instance_options[:render_attribute].split(","),"challanges.name","name")
  end

  def render_description?
    render?(instance_options[:render_attribute].split(","),"challanges.description","description")
  end

  def render_type_challange?
    render?(instance_options[:render_attribute].split(","),"challanges.type_challange","type_challange")
  end

  def render_start_date?
    render?(instance_options[:render_attribute].split(","),"challanges.start_date","start_date")
  end

  def render_end_date?
    render?(instance_options[:render_attribute].split(","),"challanges.end_date","end_date")
  end

  def render_state?
    render?(instance_options[:render_attribute].split(","),"challanges.state","state")
  end

  def render_objective?
    render?(instance_options[:render_attribute].split(","),"challanges.objective","objective")
  end


end
