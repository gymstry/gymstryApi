Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], {:provider_ignores_state => true,scope: 'public_profile,email,user_friends',info_fields:"first_name,last_name,email,picture"}
end
