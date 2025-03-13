# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '#previous_entry' do
    let(:calendar) { create(:calendar) }

    it '引数の登録日よりも前の登録日をもつ記事を返す' do
      previous_entry = create(:entry, calendar: calendar, registration_date: '2025-12-01')
      entry = build(:entry, calendar: calendar, registration_date: '2025-12-02')
      expect(entry.previous_entry.registration_date).to eq(previous_entry.registration_date)
    end

    it '引数の登録日よりも前の登録日をもつ記事が存在しない場合はnilを返す' do
      entry = build(:entry, calendar: calendar, registration_date: '2025-12-01')
      expect(entry.previous_entry).to be_nil
    end
  end
end
