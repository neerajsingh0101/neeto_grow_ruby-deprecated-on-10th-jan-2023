require 'neeto_grow_ruby/version'
require 'neeto_grow_ruby/config'
require 'neeto_grow_ruby/jobs/push_job'
require 'neeto_grow_ruby/api_service'
require 'neeto_grow_ruby/user'
require 'neeto_grow_ruby/company'

module NeetoGrowRuby
  class << self
    def config
      @config ||= NeetoGrowRuby::Config.new
    end

    def configure
      yield config
    end
  end
end
