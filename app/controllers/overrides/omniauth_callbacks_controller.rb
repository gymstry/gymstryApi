module Overrides
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    attr_reader :auth_params
    skip_before_action :set_user_by_token, raise: false
    after_action :update_response

    #skip_after_action :update_auth_header

    # intermediary route for successful omniauth authentication. omniauth does
    # not support multiple models, so we must resort to this terrible hack.
    def redirect_callbacks
      super
    end

    def omniauth_success
      if get_resource_from_auth_hash
        create_token_info
        set_token_on_resource
        create_auth_params

        if resource_class.devise_modules.include?(:confirmable)
          # don't send confirmation email!!!
          @resource.skip_confirmation!
        end

        sign_in(:user, @resource, store: false, bypass: false)

        @resource.save

        yield @resource if block_given?

        #render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
        render json: {
           stauts: "success",
           data: @resource
        }, status: :ok
      else
        render json: { data: {
            status: "Error",
            message: "Before you can make login with facebook you need to be registered in the app."
          }
        }, status: :not_found
      end


    end

    def omniauth_failure
      super
    end

    protected

    # this will be determined differently depending on the action that calls
    # it. redirect_callbacks is called upon returning from successful omniauth
    # authentication, and the target params live in an omniauth-specific
    # request.env variable. this variable is then persisted thru the redirect
    # using our own dta.omniauth.params session var. the omniauth_success
    # method will access that session var and then destroy it immediately
    # after use.  In the failure case, finally, the omniauth params
    # are added as query params in our monkey patch to OmniAuth in engine.rb
    def omniauth_params
      super
    end

    # break out provider attribute assignment for easy method extension
    def assign_provider_attrs(user, auth_hash)
      p "#{auth_hash['info']['image']}"
      user.name = auth_hash['info']['first_name'] || user.name
      user.lastname = auth_hash['info']['last_name'] || user.lastname
      user.save
    end

    # derive allowed params from the standard devise parameter sanitizer
    def whitelisted_params
      super
    end

    def resource_class(mapping = nil)
      super
    end

    def resource_name
      super
    end

    def omniauth_window_type
      super
    end

    def auth_origin_url
      super
    end

    # in the success case, omniauth_window_type is in the omniauth_params.
    # in the failure case, it is in a query param.  See monkey patch above
    def omniauth_window_type
      super
    end

    # this sesison value is set by the redirect_callbacks method. its purpose
    # is to persist the omniauth auth hash value thru a redirect. the value
    # must be destroyed immediatly after it is accessed by omniauth_success
    def auth_hash
      super
    end

    # ensure that this controller responds to :devise_controller? conditionals.
    # this is used primarily for access to the parameter sanitizers.
    def assert_is_devise_resource!
      true
    end

    # necessary for access to devise_parameter_sanitizers
    def devise_mapping
      super
    end

    def set_random_password
      super
    end

    def create_token_info
      super
    end

    def create_auth_params
      super
    end

    def set_token_on_resource
      token = BCrypt::Password.create(@token)
      @resource.tokens[@client_id] = {
        token: token,
        expiry: @expiry
      }
      @new_auth_header = @resource.build_auth_header(token, @client_id)
      @new_auth_header
    end

    def render_data(message, data)
      super
    end

    def render_data_or_redirect(message, data, user_data = {})
      super
    end

    def fallback_render(text)
        super
    end

    def get_resource_from_auth_hash
      # find or create user by provider and provider uid
      @resource = resource_class.where({
        uid:  auth_hash['info']['email']
      }).first

      if @resource
        assign_provider_attrs(@resource, auth_hash)
        #extra_params = whitelisted_params
        #@resource.assign_attributes(extra_params) if extra_params
        true
      else
        false
      end

      # sync user info with provider, update/generate auth token

      # assign any additional (whitelisted) attributes

    end

    def update_response
      response.headers.merge!(@new_auth_header) if @new_auth_header
    end


  end
end
