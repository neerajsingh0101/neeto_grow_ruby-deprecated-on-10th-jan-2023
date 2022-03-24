module NeetoGrowRuby
  module Company
    def neeto_grow_push_later
      return if NeetoGrowRuby.config.push_key.blank?

      NeetoGrowRuby::PushJob.perform_later to_global_id.to_s
    end

    def neeto_grow_push
      return if NeetoGrowRuby.config.push_key.blank?

      NeetoGrowRuby::ApiService.new.push_company \
        company: {
          identifier: neeto_grow_identifier,
          signed_up_at: neeto_grow_signed_up_at,
          properties: neeto_grow_properties.merge(name: neeto_grow_name)
        }
    end
  end
end
