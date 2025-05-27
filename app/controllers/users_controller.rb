# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.includes(entries: :calendar).find(params[:id])
  end
end
