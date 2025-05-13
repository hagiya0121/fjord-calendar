# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entries', type: :system do
  include WebMockStubs

  before do
    stub_all_requests
  end

  describe 'カレンダーに記事を登録' do
    let(:calendar) { create(:calendar) }
    let(:user) { create(:user) }
    let(:entry_date) { '[data-test="2025-12-01"]' }

    context 'ログインユーザーが記事を登録する場合' do
      before do
        sign_in user
      end

      it 'カレンダーに登録者のアイコンが表示される' do
        visit calendar_path(calendar)
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'URL', with: 'http://example.com'
        click_button '登録する'
        expect(page).to have_content('記事を登録しました')
        expect(page).to have_selector('img[src*="test_avatar1"]')
      end

      it '記事リストに表示される' do
        visit calendar_path(calendar)
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        click_button '登録する'
        expect(page).to have_link(text: '一般ユーザー', href: user_path(user))
        expect(page).to have_content('テスト記事')
        expect(page).to have_selector('img[src*="test_avatar1"]')
      end

      it 'キャンセルボタンを押すと登録モーダルを閉じることができる' do
        visit calendar_path(calendar)
        find(entry_date).click
        click_button 'キャンセル'
        expect(page.find('#entry_modal').text).to eq('')
      end
    end

    context '記事URLを登録した場合' do
      before do
        sign_in user
      end

      it 'リンクプレビューが表示される' do
        visit calendar_path(calendar)
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'URL', with: 'http://example.com'
        click_button '登録する'
        expect(page).to have_content('リンクプレビューのタイトル')
        expect(page).to have_content('リンクプレビューの説明')
        expect(page).to have_selector("img[src*='og_image']")
      end

      it 'OGPメタタグが存在しない場合はフォールバックの情報を表示する' do
        visit calendar_path(calendar)
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'URL', with: 'http://example.com/meta_without'
        click_button '登録する'
        expect(page).to have_content('フォールバック時のタイトル')
        expect(page).to have_content('フォールバック時の説明')
        expect(page).to have_selector("img[src*='favicon.png']")
      end
    end

    context '入力値が無効の場合' do
      before do
        sign_in user
      end

      it 'タイトルが未入力だと記事登録に失敗する' do
        visit calendar_path(calendar)
        find(entry_date).click
        fill_in 'タイトル', with: ''
        fill_in 'URL', with: 'http://example.com'
        click_button '登録する'
        expect(page).to have_content('タイトルを入力してください')
      end

      it '不正な形式の記事URLは登録できない' do
        visit calendar_path(calendar)
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'URL', with: 'ftp://ftp.example.com'
        click_button '登録する'
        expect(page).to have_content('記事URLの形式が不正です')
      end

      it '無効なURLを入力するとエラーメッセージが表示される' do
        visit calendar_path(calendar)
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'URL', with: 'http://invalid.example.com'
        click_button '登録する'
        expect(page).to have_content('無効なURLです')
      end
    end

    context '未ログインユーザーの場合' do
      it '記事登録ページにアクセスできない' do
        visit new_calendar_entry_path(calendar)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'カレンダーに登録した記事を更新' do
    let(:calendar) { create(:calendar) }
    let(:user) { build(:user) }
    let!(:entry) { create(:entry, calendar: calendar, user: user) }

    context 'ログインユーザーの場合' do
      before do
        sign_in user
      end

      it '登録した記事を更新できる' do
        visit calendar_path(calendar)
        click_on '編集'
        fill_in 'タイトル', with: '更新したタイトル'
        fill_in 'URL', with: 'http://example.com/updated'
        click_button '登録する'
        expect(page).to have_content('記事を更新しました')

        click_on '編集'
        expect(page).to have_field('entry[title]', with: '更新したタイトル')
        expect(page).to have_field('entry[url]', with: 'http://example.com/updated')
      end

      it '登録した記事を更新すると記事リストが更新される' do
        visit calendar_path(calendar)
        click_on '編集'
        fill_in 'タイトル', with: '更新したタイトル'
        fill_in 'URL', with: 'http://example.com/updated'
        click_button '登録する'
        expect(page).to have_content('一般ユーザー')
        expect(page).to have_content('更新したタイトル')
      end

      it '記事URLを更新するとリンクプレビューが更新される' do
        visit calendar_path(calendar)
        click_on '編集'
        fill_in 'タイトル', with: '更新したタイトル'
        fill_in 'URL', with: 'http://example.com/updated'
        click_button '登録する'
        expect(page).to have_content('更新されたリンクプレビューのタイトル')
        expect(page).to have_content('更新されたリンクプレビューの説明')
        expect(page).to have_selector("img[src*='test_updated_og_image']")
      end
    end

    context '未ログインユーザーの場合' do
      it '記事編集ボタンが表示されない' do
        visit calendar_path(calendar)
        expect(page).not_to have_link('編集')
      end

      it '記事編集ページにアクセスできない' do
        visit edit_entry_path(entry.id)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end

    context '記事の登録者以外のユーザーがログインしている場合' do
      before do
        sign_in create(:user, :second_user)
      end

      it '記事編集ボタンが表示されない' do
        visit calendar_path(calendar)
        expect(page).not_to have_link('編集')
      end

      it '記事編集ページにアクセスできない' do
        visit edit_entry_path(entry.id)
        expect(page).to have_content('アクセス権限がありません')
      end
    end
  end

  describe 'カレンダーに登録した記事を削除' do
    let(:calendar) { create(:calendar) }
    let(:user) { build(:user) }

    before do
      create(:entry, calendar: calendar, user: user)
      sign_in user
    end

    it '登録した記事を削除できる' do
      visit calendar_path(calendar)
      click_on '編集'
      accept_confirm { click_on '削除' }
      expect(page).to have_content('記事を削除しました')
      within('#calendar') do
        expect(page).to have_no_selector('img[src*="test_avatar1"]')
      end
    end

    it '記事を削除すると記事リストから削除される' do
      visit calendar_path(calendar)
      click_on '編集'
      accept_confirm('記事を削除しますか？') do
        click_on '削除'
      end
      expect(page).not_to have_content('一般ユーザー')
      expect(page).not_to have_content('エントリータイトル')
    end
  end

  describe '記事の登録制限' do
    let!(:calendar) { create(:calendar) }
    let(:primary_author) { build(:user) }
    let(:secondary_author) { build(:user, :second_user) }
    let(:viewer) { create(:user, :third_user) }

    context '登録されている記事が25件未満の場合' do
      before do
        create(:entry, user: primary_author, calendar: calendar, registration_date: '2025-12-01')
        sign_in viewer
      end

      it 'すでに記事が登録されている日付には登録ボタンが表示されない' do
        visit calendar_path(calendar)
        within('[data-test="day-1"]') do
          expect(page).not_to have_link('+')
        end
      end
    end

    context '登録されている記事が25件以上の場合' do
      before do
        create_list(:entry, 25, :sequential_date, calendar: calendar, user: primary_author)
        sign_in viewer
      end

      it '2周目が始まりカレンダーの各日付に登録ボタンが表示される' do
        visit calendar_path(calendar)
        within('#calendar') do
          expect(all('a[title="新規作成"]').size).to eq 25
        end
      end
    end

    context 'カレンダーに50件以上記事が登録されている場合' do
      before do
        create_list(:entry, 25, :sequential_date, calendar: calendar, user: primary_author)
        create_list(:entry, 25, :sequential_date, calendar: calendar, user: secondary_author)
        sign_in viewer
      end

      it '3周目が始まりカレンダーの各日付に登録ボタンが表示される' do
        visit calendar_path(calendar)
        within('#calendar') do
          expect(all('a[title="新規作成"]').size).to eq 25
        end
      end
    end
  end

  describe '記事リストの読み込み' do
    let(:calendar) { create(:calendar) }

    before do
      create_list(:entry, 75, :sequential_date, calendar: calendar)
      sign_in create(:user)
    end

    it 'スクロールするたびに記事が読み込まれ、全件表示される' do
      visit calendar_path(calendar)
      expect(page).to have_selector('article[id^="entry_"]', count: 25)

      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      expect(page).to have_selector('article[id^="entry_"]', count: 50)

      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      expect(page).to have_selector('article[id^="entry_"]', count: 75)
    end
  end

  describe '管理者による他ユーザーの記事管理' do
    let(:calendar) { create(:calendar) }

    before do
      create(:entry, calendar: calendar, user: create(:user))
    end

    it '管理者は他ユーザーの記事を削除できる' do
      sign_in create(:user, :admin)
      visit calendar_path(calendar)
      within('#entries_list') { find('a[title="編集"]').click }
      accept_confirm { click_on '削除' }
      expect(page).to have_content('記事を削除しました')
    end

    it '管理者は他ユーザーの記事を編集できる' do
      sign_in create(:user, :admin)
      visit calendar_path(calendar)
      within('#entries_list') { find('a[title="編集"]').click }
      fill_in 'タイトル', with: '管理者による更新'
      click_button '登録する'
      expect(page).to have_content('記事を更新しました')
    end
  end
end
