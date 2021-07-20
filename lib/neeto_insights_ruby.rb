require "neeto_insights_ruby/version"
require "neeto_insights_ruby/config"
require "neeto_insights_ruby/user"
require "neeto_insights_ruby/company"

module NeetoInsightsRuby
  class << self
    def config
      @config ||= NeetoInsightsRuby::Config.new
    end

    def configure
      yield config
    end
  end
end
