Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV["API_DOMAIN"] || ""
    resource(
      '*',
      headers: :any,
      expose: %w[access-token expiry token-type Authorization Current-Page Link Total-Count Total-Pages],
      methods: [:get, :patch, :put, :delete, :post, :options, :show]
    )
  end
end
