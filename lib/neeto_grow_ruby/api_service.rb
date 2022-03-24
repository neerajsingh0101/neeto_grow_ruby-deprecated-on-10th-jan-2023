module NeetoGrowRuby
  class ApiService
    attr_reader :uri

    def push_company(body)
      @uri = URI("#{config.push_endpoint}/data/v1/companies")
      process(body)
    end

    def push_user(body)
      @uri = URI("#{config.push_endpoint}/data/v1/users")
      process(body)
    end

    def process(body = {})
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = config.use_ssl

      request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
      request['X-PUSH-API-KEY'] = config.push_key
      request.body = body.to_json

      http.request(request)
    end

    private

      def config
        @_config ||= NeetoGrowRuby.config
      end
  end
end
