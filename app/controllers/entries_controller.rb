# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :set_calendar, only: %i[new create]

  def new
    @entry = Entry.new
  end

  def create
    @entry = @calendar.entries.build(entry_params)
    @entry.user = User.all[1]

    if @entry.save
      flash.now.notice = '記事を登録しました'
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def entry_params
    params.require(:entry).permit(:title, :url, :registration_date)
  end
end
