# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.includes(entries: :calendar).find_by(id: params[:id])
  end
end
