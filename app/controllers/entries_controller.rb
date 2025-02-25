# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :set_entry, only: %i[edit update destroy]

  def new
    @entry = Entry.new(calendar_id: params[:calendar_id])
  end

  def edit; end

  def create
    @entry = Entry.new(entry_params)
    @entry.calendar_id = params[:calendar_id]
    @entry.user = User.last

    if @entry.save
      flash.now[:notice] = '記事を登録しました'
      render :update_calendar, locals: { calendar: @entry.calendar }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @entry.update(entry_params)
      flash.now[:notice] = '記事を更新しました'
      render :update_calendar, locals: { calendar: @entry.calendar }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    flash.now[:notice] = '記事を削除しました'
    render :update_calendar, locals: { calendar: @entry.calendar }
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :url, :registration_date)
  end
end
