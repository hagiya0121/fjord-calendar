require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module FjordCalendar
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework nil
    end
  end
end
