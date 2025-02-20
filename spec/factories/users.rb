# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    provider_uid { SecureRandom.uuid }
    role { 0 }
    avatar_url { 'images/avatar1.png' }
  end
end
