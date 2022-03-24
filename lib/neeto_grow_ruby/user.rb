module NeetoGrowRuby
  module User
    def neeto_grow_push_later
      NeetoGrowRuby::PushJob.perform_later to_global_id.to_s
    end

    def neeto_grow_push
      return if NeetoGrowRuby.config.push_key.blank?

      NeetoGrowRuby::ApiService.new.push_user \
        user: {
          identifier: neeto_grow_identifier,
          company_identifier: neeto_grow_company_identifier,
          signed_up_at: neeto_grow_signed_up_at,
          properties: neeto_grow_properties.merge(name: neeto_grow_name)
        }
    end
  end
end
