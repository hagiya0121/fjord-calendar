# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '#previous_entry' do
    let(:calendar) { create(:calendar) }

    it '対象の記事の登録日より前の登録日を持つ記事を返す' do
      _older_entry = create(:entry, calendar: calendar, registration_date: '2025-12-01')
      previous_entry = create(:entry, calendar: calendar, registration_date: '2025-12-02')
      target_entry = create(:entry, calendar: calendar, registration_date: '2025-12-05')
      expect(target_entry.previous_entry).to eq(previous_entry)
    end

    context '対象の記事の登録日より前の登録日を持つ記事が存在しない場合' do
      it 'nilを返す' do
        target_entry = create(:entry, calendar: calendar, registration_date: '2025-12-01')
        expect(target_entry.previous_entry).to be_nil
      end
    end

    context '同じ登録日を持つ記事が複数ある場合' do
      it '作成日が最新のエントリーを返す' do
        _older_entry = create(:entry, calendar: calendar, registration_date: '2025-12-01', created_at: '2025-11-01')
        previous_entry = create(:entry, calendar: calendar, registration_date: '2025-12-01', created_at: '2025-11-02')
        target_entry = create(:entry, calendar: calendar, registration_date: '2025-12-01')
        expect(target_entry.previous_entry).to eq(previous_entry)
      end
    end
  end
end
