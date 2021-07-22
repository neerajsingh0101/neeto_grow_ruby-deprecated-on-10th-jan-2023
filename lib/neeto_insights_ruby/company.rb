module NeetoInsightsRuby
  module Company
    def neeto_insights_config
      NeetoInsightsRuby.config
    end

    def neeto_insights_push_async
      return unless neeto_insights_config.push_key.present?

      NeetoInsightsRuby::PushWorker.perform_async(self.to_global_id)
    end

    def neeto_insights_push
      return unless neeto_insights_config.push_key.present?

      uri = URI("#{neeto_insights_config.push_endpoint}/data/v1/companies")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = neeto_insights_config.use_ssl

      request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})

      request["X-PUSH-API-KEY"] = neeto_insights_config.push_key

      request.body = { "company": 
        {
          "identifier": neeto_insights_identifier, 
          "signed_up_at": neeto_insights_signed_up_at,
          properties: neeto_insights_properties.merge({"name": neeto_insights_name})
        }
      }.to_json

      response = http.request(request)
    end
  end
end