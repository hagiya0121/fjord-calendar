# frozen_string_literal: true

FactoryBot.define do
  factory :calendar do
    title { 'カレンダーのタイトル' }
    description { 'カレンダーの説明' }
    year { '2025' }
  end
end
