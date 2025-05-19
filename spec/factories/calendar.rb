# frozen_string_literal: true

FactoryBot.define do
  factory :calendar do
    year { '2025' }
    description { 'カレンダーの説明' }

    trait :sequential_years do
      sequence(:year) { |n| 2025 + n - 1 }
    end
  end
end
