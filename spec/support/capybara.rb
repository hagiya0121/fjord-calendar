# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV['HEADLESS'] == 'false'
      driven_by :selenium_chrome
    else
      driven_by :selenium_chrome_headless
    end
  end
end
