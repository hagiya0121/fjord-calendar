# frozen_string_literal: true

FactoryBot.define do
  factory :entry do
    title { 'エントリータイトル' }
    registration_date { Date.new(2025, 12, 1) }
    calendar
    user
  end
end
