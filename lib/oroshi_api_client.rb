class OroshiApiClient
  class HTTPError < StandardError
    def initialize(response)
      super "status=#{response.status} body=#{response.body}"
    end
  end

  class << self
    def connection
      Faraday::Connection.new(ENV.fetch('OROSHI_URL', nil)) do |builder|
        # builder.authorization :Bearer, "#{Rails.application.credentials.qiita[:token]}"
        builder.request :json
        builder.response :logger
        builder.response :json, content_type: "application/json"
        builder.adapter Faraday.default_adapter
      end
    end

    def base_post(url, params)
      response = connection.post do |request|
        request.url url
        request.body = JSON.generate(params)
      end

      raise OroshiApiClient::HTTPError, response unless response.success?

      response.body
    end

    def post_translate(params)
      base_post('/translate', params)
    end

    def post_translate_relations(params)
      base_post('/translate_relations', params)
    end
  end
end
