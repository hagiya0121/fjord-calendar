# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    provider_uid { SecureRandom.uuid }
    role { 0 }

    after(:build) do |user|
      user.avatar_url.attach(
        io: Rails.root.join('spec/fixtures/images/avatar.png').open,
        filename: 'sample_avatar.png',
        content_type: 'image/png'
      )
    end
  end
end
