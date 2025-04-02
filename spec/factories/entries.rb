# frozen_string_literal: true

FactoryBot.define do
  factory :entry do
    title { 'エントリータイトル' }
    registration_date { Date.new(2025, 12, 1) }
    association :calendar
    association :user

    trait :sequential_date do
      sequence(:registration_date) { |n| Date.new(2025, 12, ((n - 1) % 25) + 1) }
    end
  end
end
