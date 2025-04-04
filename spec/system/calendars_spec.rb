# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Calendars', type: :system do
  include WebMockStubs

  describe 'カレンダーの一覧表示' do
    let!(:calendars) { create_list(:calendar, 5, :sequential_years) }

    it 'カレンダーが一覧表示される' do
      visit calendars_path
      calendars.each do |calendar|
        expect(page).to have_link(calendar.title)
      end
    end

    it 'カレンダー一覧が年の新しい順に表示される' do
      visit calendars_path
      years = all('[data-test="calendar"]').map { |e| e['data-year'].to_i }
      expect(years).to eq(years.sort.reverse)
    end

    it 'カレンダーをクリックするとそのカレンダーの詳細ページに遷移する' do
      visit calendars_path
      click_on calendars.first.title
      expect(page).to have_current_path(calendar_path(calendars.first))
    end
  end

  describe 'カレンダーの新規作成' do
    context '管理者の場合' do
      before do
        sign_in create(:user, :admin)
      end

      it 'カレンダーを作成できる' do
        visit root_path
        within('header') { find('img[src*="avatar1.png"]').click }
        click_on 'カレンダーを作成'
        fill_in 'タイトル', with: '新しいカレンダー'
        fill_in '説明', with: 'カレンダーの説明です'
        click_on '登録する'
        expect(page).to have_content('カレンダーが作成されました')
      end

      it '必須項目が空だとエラーが表示される' do
        visit new_calendar_path
        click_on '登録する'
        expect(page).to have_content('タイトルを入力してください')
      end

      it '同じ年のカレンダーは作成できない' do
        create(:calendar)
        visit new_calendar_path
        fill_in 'タイトル', with: '同じ年のカレンダー'
        fill_in '説明', with: 'カレンダーの説明です'
        click_on '登録する'
        expect(page).to have_content('この年度のカレンダーはすでに作成されています')
      end
    end

    context '未ログインユーザーの場合' do
      it 'カレンダー新規作成ページにアクセスできない' do
        visit new_calendar_path
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end

    context '一般のログインユーザーの場合' do
      it 'カレンダー新規作成ページにアクセスできない' do
        sign_in build(:user)
        visit new_calendar_path
        expect(page).to have_content('アクセス権限がありません')
      end
    end
  end

  describe 'カレンダーの更新' do
    let(:calendar) { create(:calendar) }

    context '管理者の場合' do
      before do
        sign_in create(:user, :admin)
      end

      it 'カレンダーを更新できる' do
        visit calendar_path(calendar)
        click_on '編集'
        fill_in 'タイトル', with: '更新したタイトル'
        fill_in '説明', with: '更新した説明'
        click_on '更新する'
        expect(page).to have_content('カレンダーを更新しました')
        expect(page).to have_content('更新したタイトル')
        expect(page).to have_content('更新した説明')
      end

      it '必須項目が空だとエラーが表示される' do
        visit calendar_path(calendar)
        click_on '編集'
        fill_in 'タイトル', with: ''
        click_on '更新する'
        expect(page).to have_content('タイトルを入力してください')
      end

      it 'キャンセルを押すとカレンダー詳細ページにリダイレクトされる' do
        visit calendar_path(calendar)
        click_on '編集'
        click_on 'キャンセル'
        expect(page).to have_current_path(calendar_path(calendar))
      end
    end

    context '未ログインユーザーの場合' do
      it '編集ページにアクセスできない' do
        visit edit_calendar_path(calendar)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end

    context '一般のログインユーザーの場合' do
      it '編集ページにアクセスできない' do
        sign_in build(:user)
        visit edit_calendar_path(calendar)
        expect(page).to have_content('アクセス権限がありません')
      end
    end
  end

  describe 'カレンダーの詳細' do
    let(:calendar) { create(:calendar) }

    before do
      stub_all_requests
      create(:entry, calendar: calendar, url: 'http://example.com')
    end

    it 'カレンダーのタイトルと説明が表示される' do
      visit calendar_path(calendar)
      expect(page).to have_content('カレンダーのタイトル')
      expect(page).to have_content('カレンダーの説明')
    end

    it 'ユーザーアイコンが記事URLのリンクになっている' do
      visit calendar_path(calendar)
      within('#calendar') do
        expect(page).to have_selector('a[href="http://example.com"] img[src*="avatar1.png"]')
      end
    end

    it '各年の12月1日が適切な曜日位置に表示されるようにオフセットセルが挿入される' do
      (2000..2004).each do |year|
        visit calendar_path(create(:calendar, year: year))
        offset_cells = all('[data-test="offset_cell"]')
        expected_offset = Date.new(year, 12, 1).cwday - 1
        expect(offset_cells.size).to eq(expected_offset)
      end
    end

    context '管理者の場合' do
      before do
        sign_in create(:user, :admin)
      end

      it '記事登録ボタンが表示される' do
        visit calendar_path(calendar)
        expect(page).to have_link('+')
      end

      it 'カレンダー編集ボタンが表示される' do
        visit calendar_path(calendar)
        expect(page).to have_link('編集')
      end

      it '記事リストの記事に編集ボタンが表示される' do
        visit calendar_path(calendar)
        within('#entries_list') { expect(page).to have_link('編集') }
      end
    end

    context '一般のログインユーザーの場合' do
      before do
        sign_in create(:user)
      end

      it '記事登録ボタンが表示される' do
        visit calendar_path(calendar)
        expect(page).to have_link('+')
      end

      it 'カレンダー編集ボタンが表示されない' do
        visit calendar_path(calendar)
        expect(page).not_to have_link('編集')
      end

      it '記事リストの記事に編集ボタンが表示されない' do
        visit calendar_path(calendar)
        within('#entries_list') { expect(page).not_to have_link('編集') }
      end
    end

    context '未ログインユーザーの場合' do
      it '記事登録ボタンが表示されない' do
        visit calendar_path(calendar)
        expect(page).not_to have_link('+')
      end

      it 'カレンダー編集ボタンが表示されない' do
        visit calendar_path(calendar)
        expect(page).not_to have_link('編集')
      end

      it '記事リストの記事に編集ボタンが表示されない' do
        visit calendar_path(calendar)
        within('#entries_list') { expect(page).not_to have_link('編集') }
      end
    end
  end

  describe 'カレンダーの削除' do
    let(:calendar) { create(:calendar) }

    context '管理者の場合' do
      before do
        sign_in create(:user, :admin)
      end

      it 'カレンダーを削除できる' do
        visit calendar_path(calendar)
        click_on '編集'
        accept_confirm { click_on '削除' }
        expect(page).to have_content('カレンダーを削除しました')
      end
    end
  end

  describe '登録記事情報のエクスポート' do
    let(:calendar) { create(:calendar) }

    it '登録記事情報をクリップボードにコピーできる' do
      visit calendar_path(calendar)
      message = accept_alert { click_on '記事のリンクをコピー' }
      expect(message).to have_content('コピーしました！')
    end
  end
end
