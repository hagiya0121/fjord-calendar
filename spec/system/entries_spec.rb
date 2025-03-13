# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entries', type: :system do
  include WebMockStubs

  let(:calendar) { create(:calendar) }
  let(:user) { create(:user) }

  before do
    stub_all_requests
    user
  end

  describe 'カレンダーに記事を登録' do
    let(:entry_date) { '[data-test="2025-12-01"]' }

    before do
      visit calendar_path(calendar)
    end

    it '記事を登録するとカレンダーにアイコンが表示される' do
      find(entry_date).click
      fill_in 'タイトル', with: 'テスト記事'
      fill_in 'URL', with: 'http://example.com'
      click_button '保存'
      expect(page).to have_content('記事を登録しました')
      expect(page).to have_selector('img[src*="avatar1.png"]')
    end

    it '記事を登録すると記事リストに表示される' do
      find(entry_date).click
      fill_in 'タイトル', with: 'テスト記事'
      click_button '保存'
      within('#entry_2025-12-01') do
        expect(page).to have_content('一般ユーザー')
        expect(page).to have_content('テスト記事')
        expect(page).to have_selector('img[src*="avatar1.png"]')
      end
    end

    it '記事URLを登録するとリンクプレビューが表示される' do
      find(entry_date).click
      fill_in 'タイトル', with: 'テスト記事'
      fill_in 'URL', with: 'http://example.com'
      click_button '保存'
      within('#entry_2025-12-01') do
        expect(page).to have_content('リンクプレビューのタイトル')
        expect(page).to have_content('リンクプレビューの説明')
        expect(page).to have_selector("img[src*='og_image.png']")
      end
    end

    it 'OGPメタタグが存在しない場合はフォールバックの情報を表示する' do
      find(entry_date).click
      fill_in 'タイトル', with: 'テスト記事'
      fill_in 'URL', with: 'http://example.com/meta_without'
      click_button '保存'
      within('#entry_2025-12-01') do
        expect(page).to have_content('フォールバック時のタイトル')
        expect(page).to have_content('フォールバック時の説明')
        expect(page).to have_selector("img[src*='favicon.png']")
      end
    end

    it 'キャンセルボタンを押すと登録モーダルを閉じることができる' do
      find(entry_date).click
      click_button 'キャンセル'
      expect(page.find('#entry_modal').text).to eq('')
    end

    context '入力値が無効の場合' do
      it 'タイトルが未入力だと記事登録に失敗する' do
        find(entry_date).click
        fill_in 'タイトル', with: ''
        fill_in 'URL', with: 'http://example.com'
        click_button '保存'
        expect(page).to have_content('タイトルを入力してください')
      end

      it 'httpまたはhttpsで始まらないURLは登録できない' do
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'URL', with: 'ftp://ftp.example.com'
        click_button '保存'
        expect(page).to have_content('記事URLは http または https で始まるURLを入力してください')
      end

      it 'アクセスできないURLは登録できない' do
        find(entry_date).click
        fill_in 'タイトル', with: 'テスト記事'
        fill_in 'URL', with: 'http://invalid.example.com'
        click_button '保存'
        expect(page).to have_content('記事URLにアクセスできません')
      end
    end

    # 未ログインユーザーには登録ボタンが表示されない
    # 未ログインユーザーが記事登録ページにアクセスできない
  end

  describe 'カレンダーに登録した記事を更新' do
    before do
      create(:entry, calendar: calendar, user: user)
      visit calendar_path(calendar)
    end

    it '登録した記事を更新できる' do
      click_on '編集'
      fill_in 'タイトル', with: '更新したタイトル'
      fill_in 'URL', with: 'http://example.com/updated'
      click_button '保存'
      expect(page).to have_content('記事を更新しました')

      click_on '編集'
      expect(page).to have_field('entry[title]', with: '更新したタイトル')
      expect(page).to have_field('entry[url]', with: 'http://example.com/updated')
    end

    it '登録した記事を更新すると記事リストが更新される' do
      click_on '編集'
      fill_in 'タイトル', with: '更新したタイトル'
      fill_in 'URL', with: 'http://example.com/updated'
      click_button '保存'

      within('#entry_2025-12-01') do
        expect(page).to have_content('一般ユーザー')
        expect(page).to have_content('更新したタイトル')
        expect(page).to have_selector('img[src*="avatar1.png"]')
      end
    end

    it '記事URLを更新するとリンクプレビューが更新される' do
      click_on '編集'
      fill_in 'タイトル', with: '更新したタイトル'
      fill_in 'URL', with: 'http://example.com/updated'
      click_button '保存'

      within('#entry_2025-12-01') do
        expect(page).to have_content('更新されたリンクプレビューのタイトル')
        expect(page).to have_content('更新されたリンクプレビューの説明')
        expect(page).to have_selector("img[src*='updated_og_image.png']")
      end
    end

    # 未ログインユーザーは編集ボタンが表示されない
    # 他のユーザーが登録した記事の編集ボタンは表示されない
    # 未ログインユーザーが編集ページにアクセスできない
  end

  describe 'カレンダーに登録した記事を削除' do
    before do
      create(:entry, calendar: calendar, user: user)
      visit calendar_path(calendar)
    end

    it '登録した記事を削除できる' do
      click_on '編集'
      accept_confirm('記事を削除しますか？') do
        click_on '削除'
      end
      expect(page).to have_content('記事を削除しました')
      expect(page).to have_no_selector('img[src*="avatar1.png"]')
    end

    it '記事を削除すると記事リストから削除される' do
      click_on '編集'
      accept_confirm('記事を削除しますか？') do
        click_on '削除'
      end
      expect(page).to have_no_selector('#entry_2025-12-01')
    end

    # 自分の記事だけ削除できる
  end
end
