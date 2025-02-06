# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimpleCalendarHelper, type: :helper do
  include ActiveSupport::Testing::TimeHelpers

  describe '#start_weekday' do
    it '2024年12月1日は日曜日なので、6を返す' do
      expect(helper.start_weekday(2024)).to eq(6)
    end

    it '2025年12月1日は月曜日なので、0を返す' do
      expect(helper.start_weekday(2025)).to eq(0)
    end

    it '2026年12月1日は火曜日なので、1を返す' do
      expect(helper.start_weekday(2026)).to eq(1)
    end
  end

  describe '#advent_dates' do
    it '2025年のアドベントカレンダーの日付範囲を返す' do
      expect(helper.advent_dates(2025)).to eq(Date.new(2025, 12, 1)..Date.new(2025, 12, 25))
    end
  end

  describe '#today_class' do
    it '今日の日付の場合は "bg-yellow-100" を返す' do
      travel_to Time.zone.today do
        expect(helper.today_class(Time.zone.today)).to eq('bg-yellow-100')
      end
    end

    it '今日の日付以外のときは空文字を返す' do
      travel_to Time.zone.today do
        expect(helper.today_class(Time.zone.today - 1.day)).to eq('')
      end
    end
  end
end
