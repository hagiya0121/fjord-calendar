# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Calendars', type: :system do
  describe 'カレンダーの一覧表示' do
    let!(:calendars) do
      (2015..2025).map do |year|
        create(:calendar, year: year)
      end
    end

    before { visit calendars_path }

    it 'カレンダーが一覧表示される' do
      calendars.each do |calendar|
        expect(page).to have_content(calendar.title)
      end
    end

    it 'カレンダーはyearの降順で表示される' do
      years = all('[data-test="calendar"]').map { |element| element['data-year'].to_i }
      expect(years).to eq years.sort.reverse
    end

    it 'カレンダーをクリックするとそのカレンダーの詳細ページに遷移する' do
      create(:user)
      click_on '2025年のカレンダーのタイトル'
      expect(page).to have_current_path(calendar_path(calendars.last))
    end
  end

  describe 'カレンダーの新規作成' do
    before do
      create(:user)
      visit new_calendar_path
    end

    it 'カレンダーが作成される' do
      fill_in 'タイトル', with: '新しいカレンダー'
      fill_in '説明', with: 'カレンダーの説明です'
      click_on '登録する'
      expect(page).to have_content('カレンダーが作成されました')
    end

    it '必須項目が空だとエラーが表示される' do
      click_on '登録する'
      expect(page).to have_content('タイトルを入力してください')
    end

    it '同じ年のカレンダーは作成できない' do
      create(:calendar)
      fill_in 'タイトル', with: '同じ年のカレンダー'
      fill_in '説明', with: 'カレンダーの説明です'
      click_on '登録する'
      expect(page).to have_content('この年度のカレンダーはすでに作成されています')
    end

    # 管理者ではないユーザーはカレンダー作成ページにアクセスできない
  end

  describe 'カレンダーの更新' do
    let(:calendar) { create(:calendar) }

    before do
      create(:user, :admin)
      visit calendar_path(calendar)
    end

    it 'カレンダーを更新できる' do
      click_on '編集'
      fill_in 'タイトル', with: '更新したタイトル'
      fill_in '説明', with: '更新した説明'
      click_on '更新する'
      expect(page).to have_content('カレンダーを更新しました')
      expect(page).to have_content('更新したタイトル')
      expect(page).to have_content('更新した説明')
    end

    it '必須項目が空だとエラーが表示される' do
      click_on '編集'
      fill_in 'タイトル', with: ''
      click_on '更新する'
      expect(page).to have_content('タイトルを入力してください')
    end

    it 'キャンセルを押すとカレンダー詳細ページにリダイレクトされる' do
      click_on '編集'
      click_on 'キャンセル'
      expect(page).to have_current_path(calendar_path(calendar))
    end
  end

  describe 'カレンダーの削除' do
    before do
      create(:user, :admin)
      calendar = create(:calendar)
      visit calendar_path(calendar)
    end

    it 'カレンダーを削除できる' do
      click_on '編集'
      click_on '削除'
      accept_confirm
      expect(page).to have_content('カレンダーを削除しました')
    end
  end
end
