module NeetoInsightsRuby
  module User
    def neeto_insights_push_async
      Thread.new{ neeto_insights_push }
    end

    def neeto_insights_push
      config = NeetoInsightsRuby.config

      return unless config.push_key.present?

      uri = URI("#{config.push_endpoint}/data/v1/users")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = config.use_ssl

      request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})

      request["X-PUSH-API-KEY"] = config.push_key

      request.body = { "user": 
        {
          "identifier": neeto_insights_identifier, 
          "company_identifier": neeto_insights_company_identifier,
          "signed_up_at": neeto_insights_signed_up_at,
          properties: neeto_insights_properties.merge({"name": neeto_insights_name})
        }
      }.to_json

      response = http.request(request)
    end
  end
end