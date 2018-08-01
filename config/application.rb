require_relative 'boot'

require 'rails/all'
require 'twitter-bootstrap-rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Contawords
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    
    
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:es, :en, :ca]
    
    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true
    
    #set our queuing backend
    #config.active_job.queue_adapter = :sidekiq
    #config.active_job.queue_name_prefix = Rails.env

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
