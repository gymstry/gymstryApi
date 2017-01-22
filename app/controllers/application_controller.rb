class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    if resource_class == Gym
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:description,:address,:telephone,:specility,:birthday])
      devise_parameter_sanitizer.permit(:account_update, keys: [:description,:address,:telephone,:speciality,:birthday])
    elsif resource_class == Branch
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:address,:telephone])
      devise_parameter_sanitizer.permit(:account_update, keys: [:address,:telephone])
    elsif resource_class == User
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:lastname,:username,:mobile,:remaining_days,:birthday,:avatar])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,:lastname,:mobile,:remaining_days,:birthday,:avatar])
    elsif resource_class == Trainer
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:lastname,:username,:speciality,:type,:birthday,:mobile,:avatar])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,:lastname,:speciality,:type,:birthday,:mobile,:avatar])
    end
  end
end
