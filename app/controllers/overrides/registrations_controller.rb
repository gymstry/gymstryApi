module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    devise_token_auth_group :member, contains: [:gym, :branch]
    before_action :authenticate_member!, only: [:create,:update,:destroy]

    def create
      @resource            = resource_class.new(sign_up_params)
      @resource.provider   = "email"
      valid = false
      type = @resource.is_a?(Branch) ? "branch" : "user"
      type_login = current_member.is_a?(Gym) ? "gym" : "branch"
      if type == "branch" && type_login == "gym"
        @resource.gym_id = current_member.id
        valid = true
      elsif type == "user" && type_login == "branch"
        @resource.branch_id = current_member.id
        valid = true
      end
      # honor devise configuration for case_insensitive_keys
      if resource_class.case_insensitive_keys.include?(:email)
        @resource.email = sign_up_params[:email].try :downcase
      else
        @resource.email = sign_up_params[:email]
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
          if @resource.save
            yield @resource if block_given?

            unless @resource.confirmed?
              # user will require email authentication
              @resource.send_confirmation_instructions({
                client_config: params[:config_name],
                redirect_url: @redirect_url
              })

            else
              # email auth has been bypassed, authenticate user
              @client_id = SecureRandom.urlsafe_base64(nil, false)
              @token     = SecureRandom.urlsafe_base64(nil, false)

              @resource.tokens[@client_id] = {
                token: BCrypt::Password.create(@token),
                expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
              }

              @resource.save!

              update_auth_header
            end
            render_create_success
          else
            clean_up_passwords @resource
            render_create_error
          end
        rescue ActiveRecord::RecordNotUnique
          clean_up_passwords @resource
          render_create_error_email_already_exists
        end
      else
        render_foreign_key_error(type,type_login)
      end
    end

    def update
      if @resource
        type = @resource.is_a?(Branch) ? "branch" : "user"
        type_login = current_member.is_a?(Gym) ? "gym" : "branch"
        valid = false
        if type == "branch" && type_login == "gym"
          valid = true
        elsif type == "user" && type_login == "branch"
          valid = true
        end
        if valid
          if @resource.send(resource_update_method, account_update_params)
            yield @resource if block_given?
            render_update_success
          else
            render_update_error
          end
        else
          render_foreign_key_error(type,type_login)
        end
      else
        render_update_error_user_not_found
      end
    end

    def destroy
      if @resource
        type = @resource.is_a?(Branch) ? "branch" : "user"
        type_login = current_member.is_a?(Gym) ? "gym" : "branch"
        valid = false
        if type == "branch" && type_login == "gym"
          valid = true
        elsif type == "user" && type_login == "branch"
          valid = true
        end
        if valid
          @resource.destroy
          yield @resource if block_given?
          render_destroy_success
        else
          render_foreign_key_error(type,type_login)
        end
      else
        render_destroy_error
      end
    end

    protected
    def render_foreign_key_error(type,type_login)
      if type == "user"
        render json: {
          status: 'error',
          errors: ["You need to log in as a branch in order to create, update or destroy an user."]
        }, status: 401
      else
        render json: {
          status: 'error',
          errors: ["You need to log in as a gym  in order to create, update or destroy one of your branches."]
        }, status: 401
      end

   end

  end
end
