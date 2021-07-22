require 'sidekiq'

module NeetoInsightsRuby
  class PushWorker
    include ::Sidekiq::Worker

    def perform(object)
      object.neeto_insights_push
    end
  end
end
