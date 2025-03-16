# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Calendar, type: :model do
  let(:calendar) { create(:calendar) }

  describe '#entry_on?' do
    let(:date) { Date.new(2025, 12, 1) }

    it 'カレンダーに記事が登録されている場合はtrueを返す' do
      create(:entry, calendar: calendar, registration_date: date)
      expect(calendar.entry_on?(date)).to be(true)
    end

    it 'カレンダーに記事が登録されてないときはfalseを返す' do
      expect(calendar.entry_on?(date)).to be(false)
    end
  end

  describe '#max_entries' do
    it 'カレンダーに登録されている記事が25件未満のときは1を返す' do
      create_list(:entry, 24, calendar: calendar)
      expect(calendar.max_entries).to be(1)
    end

    it 'カレンダーに登録されている記事が25件以上のときは2を返す' do
      create_list(:entry, 25, calendar: calendar)
      expect(calendar.max_entries).to be(2)
    end

    it 'カレンダーに登録されている記事が50件以上のときは3を返す' do
      create_list(:entry, 50, calendar: calendar)
      expect(calendar.max_entries).to be(3)
    end
  end
end
