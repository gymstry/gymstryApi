class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :add_headers_limit

  protected
  def configure_permitted_parameters
    if resource_class == Gym
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:description,:address,:telephone,:speciality,:birthday,:resource_class])
      devise_parameter_sanitizer.permit(:account_update, keys: [:description,:address,:telephone,:speciality,:birthday,:resource_class])
    elsif resource_class == Branch
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:address,:telephone,:resource_class])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,:address,:telephone,:resource_class])
    elsif resource_class == User
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:lastname,:username,:mobile,:remaining_days,:birthday,:avatar,:objective,:gender,:provider,:resource_class])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,:lastname,:mobile,:remaining_days,:birthday,:avatar,:objective,:gender,:provider,:resource_class])
    elsif resource_class == Trainer
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:lastname,:username,:speciality,:type_trainer,:birthday,:mobile,:avatar,:provider,:resource_class])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,:lastname,:speciality,:type_trainer,:birthday,:mobile,:avatar,:provider,:resource_class])
    elsif resource_class == Admin
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:username,:resource_class])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,:resource_class])
    end
  end

  def add_headers_limit
    count = request.env['rack.attack.throttle_data']["req/ip"][:count]
    limit = request.env['rack.attack.throttle_data']["req/ip"][:limit]
    period = request.env['rack.attack.throttle_data']["req/ip"][:period]
    now = Time.now
    headers = {
      'X-RateLimit-Limit' => limit,
      'X-RateLimit-Remaining' => limit - count,
      'X-RateLimit-Reset' => (now + (period - now.to_i % period)).to_s
    }
    response.headers.merge!(headers)
  end
end
