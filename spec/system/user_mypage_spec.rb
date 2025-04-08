# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'マイページ', type: :system do
  include WebMockStubs

  before do
    stub_all_requests
  end

  describe 'アクセス' do
    let(:user) { create(:user) }

    context 'ログインユーザーの場合' do
      before do
        sign_in user
      end

      it '自分のマイページにアクセスできる' do
        visit root_path
        within('header') { find('img[src*="avatar1.png"]').click }
        click_on 'マイページ'
        expect(page).to have_current_path(user_path(user))
        expect(page).to have_content('一般ユーザー')
        expect(page).to have_selector('img[src*="avatar1.png"]')
      end
    end

    context '未ログインユーザーの場合' do
      it 'マイページにアクセスできない' do
        visit user_path(user)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe '表示内容' do
    let(:user) { create(:user) }
    let(:calendar) { create(:calendar) }
    let!(:entry) { create(:entry, url: 'http://example.com', calendar: calendar, user: user) }

    before do
      sign_in user
    end

    it '登録カレンダーと登録記事タイトルが表示される' do
      visit user_path(user)
      expect(page).to have_link('2025年のカレンダーのタイトル', href: calendar_path(calendar))
      expect(page).to have_content('エントリータイトル')
    end

    it 'タイトルタグが正しく表示される' do
      visit user_path(user)
      expect(page).to have_title("#{user.name}のマイページ")
    end

    context '記事URLが登録されている場合' do
      it 'リンクプレビューが表示される' do
        visit user_path(user)
        expect(page).to have_link('リンクプレビューのタイトル', href: entry.url)
        expect(page).to have_content('リンクプレビューの説明')
        expect(page).to have_selector("img[src*='og_image.png']")
      end
    end
  end
end
