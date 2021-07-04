Rails.application.config.middleware.use Rack::Attack

class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 
  throttle('req/ip', limit: 10, period: 60 ) do |req|

    # if req.path == '/api/v1/users' && req.post? 
    #   req.params['email'].presence
    #  end 
    
   #Apply all users routes url rate limit
    if req.path == '/api/v1/users' 
      req.ip
    end
    #req.ip // apply full site rate limit
  end


  self.throttled_response = ->(env) {
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    [
      429,
      {'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s},
      [{error: "You have fired too many requests. Please wait for some time."}.to_json]
    ]
  }

end