# NeetoInsightsRuby

This gem is the Ruby wrapper for the data push API of neetoInsights.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neeto_insights_ruby', git: "https://github.com/bigbinary/neeto-insights-ruby"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install neeto_insights_ruby

## Usage

neetoInsights tracks 2 entities: `user` and `company`. You need to figure out the models in your application that correspond to these two entities and then map them to `user` and `company`. Mapping involves including a module from the gem in your model and defining a few mandatory attributes and as many custom attributes as you need.

Suppose in your application `OrganizationUser` is the user model and `Organization` is the company to which user belongs. Follow the steps below to integrate them with neetoInsights:

### Initializer

Add a file `config/initializers/neeto_insights.rb`

```
NeetoInsightsRuby.configure do |config|
  config.push_key = ENV["NEETO_INSIGHTS_PUSH_KEY"]
  config.user_model    = "OrganizationUser"
  config.company_model = "Organization"
end
```

The gem will try to push data to neetoInsights only if `push_key` is configured. You can skip `development`, `test` environments by not providing a `push_key`.

### User mapping

```
class OrganizationUser < ApplicationRecord
  include NeetoInsightsRuby::User
  include NeetoInsights::UserConcern
end

# frozen_string_literal: true

module NeetoInsights
  module UserConcern
    extend ActiveSupport::Concern

    # Mandatory attributes
    
    def neeto_insights_identifier
      self.id
    end

    def neeto_insights_name
      user.name
    end

    # Optional - provide this if your user belongs to a company/organization 
    # and you want to record this relationship in neetoInsights
    def neeto_insights_company_identifier
      organization.id
    end

    def neeto_insights_signed_up_at
      created_at
    end

    # Custom Attributes
    
    def neeto_insights_properties
      {
        user_id: user.id,
        last_time_entry: last_time_entry&.recorded_on,
        recent_projects: recent_projects,
        role: role,
        verified: user.verified
      }
    end

    def last_time_entry
      # code to fetch the last time entry of the user.
    end

    def recent_projects
      # code to fetch the recent projects of the user.
    end
  end
end
```

### Company mapping

```
class Organization < ApplicationRecord
  include NeetoInsightsRuby::Company
  include NeetoInsights::CompanyConcern
end

# frozen_string_literal: true

module NeetoInsights
  module CompanyConcern
    extend ActiveSupport::Concern
    
    def neeto_insights_identifier
      self.id
    end

    def neeto_insights_name
      name
    end

    def neeto_insights_signed_up_at
      created_at
    end

    def neeto_insights_properties
      {
        clients_count: clients.active.count,
        projects_count: projects.active.count,
        invoices_count: invoices.count
      }
    end
  end
end
```

### Push data to neetoInsights

```
@organization_user.neeto_insights_push
@organization.neeto_insights_push
```

### Push strategy

You can either use `neeto_insights_push` or `neeto_insights_push_async` to push data to neetoInsights server. 

`neeto_insights_push` sends data asynchronously and would affect the performance of the source app.
`neeto_insights_push` sends data asynchronously. This is the preferred approach. But this method uses Sidekiq, and *can be used only if SideKiq is configured in your app.*

*This gem will not push any data automatically to neetoInsights. Data push happens only when `neeto_insights_push` or `neeto_insights_push_async` is called.*
