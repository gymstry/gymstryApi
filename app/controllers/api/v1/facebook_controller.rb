class Api::V1::FacebookController < ApplicationController
  after_action :update_response, only: [:login_facebook]
  @new_auth_header = nil
  def login_facebook
    resource = nil
    if params[:type].downcase == "user"
      user_params
      resource = User.find_by_email(params[:email])
    elsif params[:type].downcase == "trainer"
      trainer_params
      resource = Trainer.find_by_email(params[:email])
    end
    if resource
      if params[:operation] == "update"
        resource.set_attributes(params)
        if resource.save
          @new_auth_header = resource.set_token
          render_success_login(resource)
        else
          render_error_login(resource)
        end
      elsif params[:operation] == "log in"
        @new_auth_header = resource.set_token
        render_success_login(resource)
      end
    else
      render_not_found_login
    end
  end

  protected

  def update_response
    response.headers.merge!(@new_auth_header) if @new_auth_header
  end

  def is_json_api
    return false unless defined?(ActiveModel::Serializer)
    return ActiveModel::Serializer.setup do |config|
      config.adapter == :json_api
    end if ActiveModel::Serializer.respond_to?(:setup)
    return ActiveModelSerializers.config.adapter == :json_api
  end

  def resource_data(resource,opts={})
    response_data = opts[:resource_json] || resource.as_json
    if is_json_api
      response_data['type'] = resource.class.name.parameterize
    end
    response_data
  end

  def render_success_login(resource)
    render json: {
      status: 'success',
      data: resource_data(resource)
    },status: 200
  end

  def render_not_found_login
    render json: {
      status: 'error',
      error: "The user with that email was not found"
    },status: 404
  end

  def resource_errors(resource)
    return user.errors.to_hash.merge(full_messages: resource.errors.full_messages)
  end

  def render_error_login(resource)
    render json: {
      status: 'error',
      data: resource_data(resource),
      error: resource_errors(resource)
    }, status: 422
  end

  def user_params
    params.permit(:email,:name,:lastname,:birthday,:mobile,:avatar,:operation)
  end

  def trainer_params
    params.permit(:email,:name,:lastname,:mobile,:speciality,:birthday,:avatar,:operation)
  end
end
