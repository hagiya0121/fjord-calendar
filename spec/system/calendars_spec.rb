# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Calendars', type: :system do
  describe 'カレンダーの新規作成' do
    before do
      visit new_calendar_path
    end

    it 'カレンダーが作成される' do
      fill_in 'タイトル', with: '新しいカレンダー'
      fill_in '説明', with: 'カレンダーの説明です'
      click_on '作成'
      expect(page).to have_content('カレンダーが作成されました')
    end

    it '必須項目が空だとエラーが表示される' do
      click_on '作成'
      expect(page).to have_content('タイトルを入力してください')
    end

    it '同じ年のカレンダーは作成できない' do
      create(:calendar)
      fill_in 'タイトル', with: '同じ年のカレンダー'
      fill_in '説明', with: 'カレンダーの説明です'
      click_on '作成'
      expect(page).to have_content('この年度のカレンダーはすでに作成されています')
    end
  end
end
