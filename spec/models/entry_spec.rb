# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '#previous_entry' do
    let(:calendar) { create(:calendar) }

    it '対象の記事の登録日より前の登録日を持つ記事を返す' do
      create(:entry, calendar: calendar, registration_date: '2025-12-01')
      create(:entry, calendar: calendar, registration_date: '2025-12-02')
      target_entry = create(:entry, calendar: calendar, registration_date: '2025-12-05')
      expect(target_entry.previous_entry.registration_date).to eq(Date.parse('2025-12-02'))
    end

    context '対象の記事の登録日より前の登録日を持つ記事が存在しない場合' do
      it 'nilを返す' do
        target_entry = create(:entry, calendar: calendar, registration_date: '2025-12-01')
        expect(target_entry.previous_entry).to be_nil
      end
    end
  end
end
