# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { '一般ユーザー' }
    provider_uid { SecureRandom.uuid }
    role { 0 }
    avatar_url { 'images/avatar1.png' }

    trait :admin do
      role { 1 }
      name { '管理者ユーザー' }
    end
  end
end
