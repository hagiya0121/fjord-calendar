# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { '一般ユーザー' }
    provider { 'github' }
    provider_uid { SecureRandom.uuid }
    role { 0 }
    avatar_url { 'test_avatar1.png' }

    trait :second_user do
      name { '2番目のユーザー' }
      avatar_url { 'test_avatar2.png' }
    end

    trait :third_user do
      name { '3番目のユーザー' }
      avatar_url { 'test_avatar3.png' }
    end

    trait :admin do
      role { 1 }
      name { '管理者ユーザー' }
    end
  end
end
