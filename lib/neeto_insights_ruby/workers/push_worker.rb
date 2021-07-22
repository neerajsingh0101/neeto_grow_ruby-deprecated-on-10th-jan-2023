require 'sidekiq'

module NeetoInsightsRuby
  class PushWorker
    include ::Sidekiq::Worker

    def perform(gid)
      object = GlobalID::Locator.locate gid
      object.neeto_insights_push
    end
  end
end
