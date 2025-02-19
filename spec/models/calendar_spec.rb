# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe '#entry_on?' do
    let(:calendar) { create(:calendar) }
    let(:date) { Date.new(2025, 12, 1) }

    it 'カレンダーに記事が登録されている場合はtrueを返す' do
      create(:entry, calendar: calendar, registration_date: date)
      expect(calendar.entry_on?(date)).to be(true)
    end

    it 'カレンダーに記事が登録されてないときはfalseを返す' do
      expect(calendar.entry_on?(date)).to be(false)
    end
  end
end
