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

  describe '#update_meta_info' do
    include WebMockStubs

    before do
      stub_all_requests
    end

    context '有効なURLの場合' do
      it 'メタ情報を更新する' do
        entry = create(:entry, url: 'http://example.com')
        entry.update_meta_info
        expect(entry.meta_title).to eq('リンクプレビューのタイトル')
        expect(entry.meta_description).to eq('リンクプレビューの説明')
        expect(entry.meta_image_url).to eq('test_og_image.png')
      end
    end

    context 'OGPが設定されていない場合' do
      it 'フォールバックのメタ情報を使用する' do
        entry = create(:entry, url: 'http://example.com/meta_without')
        entry.update_meta_info
        expect(entry.meta_title).to eq('フォールバック時のタイトル')
        expect(entry.meta_description).to eq('フォールバック時の説明')
        expect(entry.meta_image_url).to eq('http://example.com/favicon.png')
      end
    end

    context '無効なURLの場合' do
      it 'エラーメッセージを設定する' do
        entry = create(:entry, url: 'http://invalid.example.com')
        entry.update_meta_info
        expect(entry.meta_title).to eq('無効なURLです')
        expect(entry.meta_description).to be_nil
        expect(entry.meta_image_url).to be_nil
      end
    end
  end
end
