class NeetoGrowRuby::PushJob < ActiveJob::Base
  queue_as :neeto_grow_push

  def perform(gid)
    object = GlobalID::Locator.locate gid
    object.neeto_grow_push
  end
end
