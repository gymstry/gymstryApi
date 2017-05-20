class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  throttle('req/ip', :limit => 1800, :period => 1.hours) do |req|
    req.ip
  end
  Rack::Attack.blocklist('allow2ban login scrapers') do
    Rack::Attack.Allow2Ban.filter(req.ip, :maxretry => 20, :findtime => 1.minute, :bantime => 1.hour) do
      (req.path == '/api/v1/gym_auth/sign_in' && req.post?) ||
        (req.path == '/api/v1/branch_auth/sign_in' && req.post?) ||
          (req.path == '/api/v1/trainer_auth/sign_in' && req.post?) ||
            (req.path == '/api/v1/auth/sign_in' && req.post?)
    end
  end
  Rack::Attack.throttle('logins/email', :limit => 6, :period => 60.seconds) do |req|
    req.params['email'] if (req.path == '/api/v1/gym_auth/sign_in' && req.post?) ||
     (req.path == '/api/v1/branch_auth/sign_in' && req.post?) ||
        (req.path == '/api/v1/trainer_auth/sign_in' && req.post?) ||
          (req.path == '/api/v1/auth/sign_in' && req.post?)
  end
  
  Rack::Attack.throttled_response = lambda do |env|
  now = Time.now
  match_data = env['rack.attack.match_data']

  headers = {
    'X-RateLimit-Limit' => match_data[:limit].to_s,
    'X-RateLimit-Remaining' => '0',
    'X-RateLimit-Reset' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s
  }

  [ 429, headers, [{ data: {error: "Limit reached. Retry later."}}.to_json]]
  end
end
