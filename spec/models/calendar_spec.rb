# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe '#max_entries' do
    let(:calendar) { build(:calendar) }

    it 'カレンダーに登録されている記事が0件のときに1を返す' do
      expect(calendar.max_entries).to be(1)
    end

    it 'カレンダーに登録されている記事が24件のときに1を返す' do
      create_list(:entry, 24, calendar: calendar)
      expect(calendar.max_entries).to be(1)
    end

    it 'カレンダーに登録されている記事が25件のときに2を返す' do
      create_list(:entry, 25, calendar: calendar)
      expect(calendar.max_entries).to be(2)
    end

    it 'カレンダーに登録されている記事が49件のときに2を返す' do
      create_list(:entry, 49, calendar: calendar)
      expect(calendar.max_entries).to be(2)
    end

    it 'カレンダーに登録されている記事が50件のときに3を返す' do
      create_list(:entry, 50, calendar: calendar)
      expect(calendar.max_entries).to be(3)
    end

    it 'カレンダーに登録されている記事が74件のときに3を返す' do
      create_list(:entry, 74, calendar: calendar)
      expect(calendar.max_entries).to be(3)
    end
  end

  describe '#start_date' do
    let(:calendar) { build(:calendar, year: 2025) }

    it 'カレンダーの年の12月1日を返す' do
      expect(calendar.start_date).to eq(Date.new(2025, 12, 1))
    end
  end

  describe '#to_param' do
    let(:calendar) { build(:calendar, year: 2025) }

    it 'カレンダーの年を文字列として返す' do
      expect(calendar.to_param).to eq('2025')
    end
  end

  describe '#open?' do
    include ActiveSupport::Testing::TimeHelpers

    let(:calendar) { build(:calendar, year: 2025) }

    context '現在の日付が12月25日までのとき' do
      it 'trueを返す' do
        travel_to Date.new(2025, 12, 25) do
          expect(calendar.open?).to be true
        end
      end
    end

    context '現在の日付が12月26日以降のとき' do
      it 'falseを返す' do
        travel_to Date.new(2025, 12, 26) do
          expect(calendar.open?).to be false
        end
      end
    end
  end
end
