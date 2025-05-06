# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include Devise::Controllers::Rememberable

    skip_before_action :verify_authenticity_token, only: :github

    def github
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'GitHub')
        remember_me(@user)
      else
        set_flash_message(:notice, :failure, kind: 'GitHub', reason: 'ユーザー登録に失敗しました')
      end

      redirect_to after_sign_in_path_for(@user)
    end

    def failure
      redirect_to root_path, alert: 'GitHub認証に失敗しました。'
    end
  end
end
