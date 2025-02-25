# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Articles', type: :system do
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
      expect(page).to have_selector('img[src*="avatar1.png"]')
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
  end
end
