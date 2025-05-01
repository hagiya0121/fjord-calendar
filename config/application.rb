require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module FjordCalendar
  class Application < Rails::Application
    config.load_defaults 7.2
    config.i18n.default_locale = :ja
    config.active_model.i18n_customize_full_message = true

    config.autoload_lib(ignore: %w(assets tasks))

    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework nil
    end
  end
end
