# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :set_calendar, only: %i[new create]
  before_action :set_entry, only: %i[edit update]

  def new
    @entry = @calendar.entries.build
  end

  def edit
    @calendar = @entry.calendar
  end

  def create
    @entry = @calendar.entries.build(entry_params)
    @entry.user = User.last

    if @entry.save
      flash.now.notice = '記事を登録しました'
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @calendar = @entry.calendar
    if @entry.update(entry_params)
      flash.now.notice = '記事を更新しました'
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :url, :registration_date)
  end
end
