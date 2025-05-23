# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :system

  # Rails8のルートの遅延読み込みが原因で、spec単体実行時にDeviseのsign_inが失敗する
  # 対策としてテスト前に明示的にルートを読み込ませる
  config.before(:suite) do
    Rails.application.routes_reloader.execute_unless_loaded
  end
end
