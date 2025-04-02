# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  include OmniAuthMock

  describe 'ユーザー登録' do
    before do
      mock_github_auth
    end

    context 'ログインに成功した場合' do
      it 'フラッシュメッセージが表示される' do
        visit root_path
        click_on 'ログイン'
        expect(page).to have_content('GitHub アカウントによる認証に成功しました。')
      end

      it '直前にいたページにリダイレクトされる' do
        calendar = create(:calendar)
        visit calendar_path(calendar)
        click_on 'ログイン'
        expect(page).to have_current_path(calendar_path(calendar))
      end
    end

    context 'ログインに失敗した場合' do
      before do
        mock_github_auth_failure
      end

      it 'エラーメッセージが表示される' do
        visit root_path
        click_on 'ログイン'
        expect(page).to have_content('GitHub認証に失敗しました。')
      end
    end

    context 'ログイン済みの場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'ヘッダーにログインユーザーのアイコンが表示される' do
        visit root_path
        within('header') { expect(page).to have_selector('img[src*="avatar1.png"]') }
      end

      it 'ログアウトできる' do
        visit root_path
        within('header') { find('img[src*="avatar1.png"]').click }
        click_on 'ログアウト'
        expect(page).to have_content('ログアウトしました。')
      end
    end
  end
end
