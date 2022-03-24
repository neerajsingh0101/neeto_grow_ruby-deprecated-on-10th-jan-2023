# NeetoGrowRuby

This gem is the Ruby wrapper for the data push API of neetoGrow.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neeto_grow_ruby', git: "https://github.com/bigbinary/neeto_grow_ruby"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install neeto_grow_ruby

## Usage

neetoGrow tracks 2 entities: `user` and `company`. You need to figure out the models in your application that correspond to these two entities and then map them to `user` and `company`. Mapping involves including a module from the gem in your model and defining a few mandatory attributes and as many custom attributes as you need.

Suppose in your application `User` is the user model and `Organization` is the company to which user belongs. Follow the steps below to integrate them with neetoGrow:

### Initializer

Add a file `config/initializers/neeto_grow.rb`

```
NeetoGrowRuby.configure do |config|
  config.push_key = ENV["NEETO_GROW_PUSH_KEY"]
  config.user_model = "User"
  config.company_model = "Organization"
end
```

The gem will try to push data to neetoGrow only if `push_key` is configured. You can skip `development`, `test` environments by not providing a `push_key`.

### User mapping

```
class User < ApplicationRecord
  include NeetoGrowRuby::User
  include NeetoGrow::UserConcern
end

# frozen_string_literal: true

module NeetoGrow
  module UserConcern
    extend ActiveSupport::Concern

    # Mandatory attributes
    
    def neeto_grow_identifier
      self.id
    end

    def neeto_grow_name
      user.name
    end

    # Optional - provide this if your user belongs to a company/organization 
    # and you want to record this relationship in neetoGrow
    def neeto_grow_company_identifier
      organization.id
    end

    def neeto_grow_signed_up_at
      created_at
    end

    # Custom Attributes
    
    def neeto_grow_properties
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
  include NeetoGrowRuby::Company
  include NeetoGrow::CompanyConcern
end

# frozen_string_literal: true

module NeetoGrow
  module CompanyConcern
    extend ActiveSupport::Concern
    
    def neeto_grow_identifier
      self.id
    end

    def neeto_grow_name
      name
    end

    def neeto_grow_signed_up_at
      created_at
    end

    def neeto_grow_properties
      {
        clients_count: clients.active.count,
        projects_count: projects.active.count,
        invoices_count: invoices.count
      }
    end
  end
end
```

### Push data to neetoGrow

```
@organization_user.neeto_grow_push
@organization.neeto_grow_push
```

### Push strategy

You can either use `neeto_grow_push` or `neeto_grow_push_later` to push data to neetoGrow server.

`neeto_grow_push` sends data synchronously and would affect the performance of the source app.

`neeto_grow_push_later` sends data asynchronously. This is the preferred approach. This method enqueues a job in `neeto_grow_push` queue. It needs the background workers up and running.

This gem will not push any data automatically to neetoGrow. Data push happens only when `neeto_grow_push` or `neeto_grow_push_later` are called.

