BCrypt::Engine.cost = BCrypt::Engine::MIN_COST if Rails.env.test?
