# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :set_entry, only: %i[edit update destroy]
  before_action :authenticate_user!

  def new
    @entry = Entry.new(calendar_id: params[:calendar_id], registration_date: params[:registration_date])
  end

  def edit; end

  def create
    @entry = Entry.new(entry_params)
    @entry.calendar_id = params[:calendar_id]
    @entry.user = current_user

    if @entry.save
      flash.now[:notice] = '記事を登録しました'
      render :create, locals: { entry: @entry }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @entry.update(entry_params)
      flash.now[:notice] = '記事を更新しました'
      render :update, locals: { entry: @entry }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    flash.now[:notice] = '記事を削除しました'
    render :destroy, locals: { entry: @entry }
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :url, :registration_date)
  end
end
