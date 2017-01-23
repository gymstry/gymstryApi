module Utility
  def set_token_resource(resource)
    client_id = SecureRandom.urlsafe_base64(nil, false)
    token     = SecureRandom.urlsafe_base64(nil, false)

    resource.tokens[client_id] = {
      token: BCrypt::Password.create(token),
      expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
    }
    new_auth_header = resource.build_auth_header(token, client_id)
    new_auth_header

  end
end
