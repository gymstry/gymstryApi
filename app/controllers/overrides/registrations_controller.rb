module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    devise_token_auth_group :member, contains: [:gym, :branch]
    before_action :authenticate_member!, only: [:create]

    def create
      @resource1            = resource_class.new(sign_up_params)
      @resource1.provider   = "email"
      valid = false
      type = @resource1.is_a?(Branch) ? "branch" : "user"
      type_login = current_member.is_a?(Gym) ? "gym" : "branch"
      if type == "branch" && type_login == "gym"
        @resource1.gym_id = current_member.id
        valid = true
        p @resource1
      elsif type == "user" && type_login == "branch"
        @resource1.branch_id = current_member.id
        valid = true
      end
      # honor devise configuration for case_insensitive_keys
      if resource_class.case_insensitive_keys.include?(:email)
        @resource1.email = sign_up_params[:email].try :downcase
      else
        @resource1.email = sign_up_params[:email]
      end

      # give redirect value from params priority
      @redirect_url = params[:confirm_success_url]

      # fall back to default value if provided
      @redirect_url ||= DeviseTokenAuth.default_confirm_success_url

      # success redirect url is required
      if resource_class.devise_modules.include?(:confirmable) && !@redirect_url
        return render_create_error_missing_confirm_success_url
      end

      # if whitelist is set, validate redirect_url against whitelist
      if DeviseTokenAuth.redirect_whitelist
        unless DeviseTokenAuth::Url.whitelisted?(@redirect_url)
          return render_create_error_redirect_url_not_allowed
        end
      end

      if valid
        begin
          # override email confirmation, must be sent manually from ctrl
          resource_class.set_callback("create", :after, :send_on_create_confirmation_instructions)
          resource_class.skip_callback("create", :after, :send_on_create_confirmation_instructions)
          if @resource1.save
            yield @resource1 if block_given?

            unless @resource1.confirmed?
              # user will require email authentication
              @resource1.send_confirmation_instructions({
                client_config: params[:config_name],
                redirect_url: @redirect_url
              })

            else
              # email auth has been bypassed, authenticate user
              @client_id = SecureRandom.urlsafe_base64(nil, false)
              @token     = SecureRandom.urlsafe_base64(nil, false)

              @resource1.tokens[@client_id] = {
                token: BCrypt::Password.create(@token),
                expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
              }

              @resource1.save!

              update_auth_header
            end
            render_create_success
          else
            clean_up_passwords @resource1
            render_create_error
          end
        rescue ActiveRecord::RecordNotUnique
          clean_up_passwords @resource1
          render_create_error_email_already_exists
        end
      else
        render_foreign_key_error(type,type_login)
      end
    end

    def update
      if @resource
        @resource1 = @resource
        if @resource1.send(resource_update_method, account_update_params)
          yield @resource1 if block_given?
          render_update_success
        else
          render_update_error
        end
      else
        render_update_error_user_not_found
      end
    end

    def destroy
      if @resource
        @resource1 = @resource
        @resource1.destroy
        yield @resource1 if block_given?
        render_destroy_success
      else
        render_destroy_error
      end
    end

    protected
    def render_foreign_key_error(type,type_login)
      if type == "user"
        render json: {
          status: 'error',
          errors: ["You need to log in as a branch in order to create an user."]
        }, status: 401
      else
        render json: {
          status: 'error',
          errors: ["You need to log in as a gym  in order to create one a branch."]
        }, status: 401
      end

   end

   def resource_data(opts={})
      response_data = opts[:resource_json] || @resource1.as_json
      if is_json_api
        response_data['type'] = @resource1.class.name.parameterize
      end
      response_data
    end

    def resource_errors
      return @resource1.errors.to_hash.merge(full_messages: @resource1.errors.full_messages)
    end

  end
end
