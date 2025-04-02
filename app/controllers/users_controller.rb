# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.includes(entries: :calendar).find_by(id: params[:id])
  end
end
