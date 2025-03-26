# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :github

    def github
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
      else
        session['devise.github_data'] = request.env['omniauth.auth'].except(:extra)
      end

      redirect_to after_sign_in_path_for(@user)
    end

    def failure
      redirect_to root_path, alert: 'GitHub認証に失敗しました。'
    end
  end
end
