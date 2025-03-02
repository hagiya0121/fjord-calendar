# frozen_string_literal: true

FactoryBot.define do
  factory :calendar do
    year { '2025' }
    title { "#{year}年のカレンダーのタイトル" }
    description { 'カレンダーの説明' }
  end
end
