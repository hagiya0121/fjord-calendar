# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe '#entry_on?' do
    let(:calendar) { build(:calendar) }
    let(:date) { Date.new(2025, 12, 1) }

    context 'カレンダーに記事が登録されている場合' do
      it 'trueを返す' do
        create(:entry, calendar: calendar, registration_date: date)
        expect(calendar.entry_on?(date)).to be(true)
      end
    end

    context 'カレンダーに記事が登録されていない場合' do
      it 'falseを返す' do
        expect(calendar.entry_on?(date)).to be(false)
      end
    end
  end

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
end
