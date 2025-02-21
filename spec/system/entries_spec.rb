# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entries', type: :system do
  describe 'カレンダーに記事を登録' do
    before do
      create(:user)
      calendar = create(:calendar)
      visit calendar_path(calendar)
    end

    it 'カレンダーに記事を登録できる' do
      all('a', text: '+')[0].click
      fill_in 'タイトル', with: 'テスト記事'
      click_button '保存'
      expect(page).to have_content '記事を登録しました'
      expect(page).to have_selector('img[src*="avatar.png"]')
    end

    it 'タイトルが未入力だと記事登録に失敗する' do
      all('a', text: '+')[0].click
      fill_in 'タイトル', with: ''
      click_button '保存'
      expect(page).to have_content 'タイトルを入力してください'
    end

    it 'キャンセルボタンでモーダルを閉じることができる' do
      all('a', text: '+')[0].click
      click_button 'キャンセル'
      expect(page.find('#entry_modal').text).to eq('')
    end

    # 未ログインユーザーには登録ボタンが表示されない
    # 未ログインユーザーが記事登録ページにアクセスできない
  end

  describe 'カレンダーに登録した記事を編集' do
    before do
      calendar = create(:calendar)
      user = create(:user)
      create(:entry, calendar: calendar, user: user)
      visit calendar_path(calendar)
    end

    it 'カレンダーに登録した記事を編集できる' do
      click_link '編集'
      fill_in 'タイトル', with: '更新後のタイトル'
      fill_in 'URL', with: '更新後のURL'
      click_button '保存'
      expect(page).to have_content '記事を更新しました'

      click_link '編集'
      expect(page).to have_field('entry[title]', with: '更新後のタイトル')
      expect(page).to have_field('entry[url]', with: '更新後のURL')
    end

    # 未ログインユーザーは編集ボタンが表示されない
    # 他のユーザーが登録した記事の編集ボタンは表示されない
    # 未ログインユーザーが編集ページにアクセスできない
  end
end
