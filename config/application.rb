require_relative "boot"

require "rails/all"

require 'dotenv/load'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QuickDside
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    if Rails.env.production?
      config.action_mailer.default_url_options = { host: 'https://quickdside.onrender.com' }
    else
      config.action_mailer.default_url_options = { host: '127.0.0.1', port: 3000 }
    end
    
  end
end
