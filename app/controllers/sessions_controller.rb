# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    user = User.find_or_create_by(provider_uid: auth['uid']) do |u|
      u.name = auth['info']['nickname']
      u.avatar_url = auth['info']['image']
    end

    session[:user_id] = user.id
    redirect_to root_path, notice: 'ログインしました'
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
