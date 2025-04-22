# frozen_string_literal: true

class CalendarsController < ApplicationController
  before_action :set_calendar, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authenticate_admin!, except: %i[index show]

  def index
    @calendars = Calendar.includes(entries: :user).order(year: :desc)
  end

  def show
    @entries = @calendar.entries.order(:registration_date, :created_at).page(params[:page]).per(25)
  end

  def new
    @calendar = Calendar.new
  end

  def edit; end

  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.year = Time.current.year

    if @calendar.save
      redirect_to @calendar, notice: 'カレンダーが作成されました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @calendar.update(calendar_params)
      flash[:notice] = 'カレンダーを更新しました'
      redirect_to calendar_path(@calendar)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @calendar.destroy
    redirect_to calendars_path, notice: 'カレンダーを削除しました'
  end
end

private

def set_calendar
  @calendar = Calendar.find(params[:id])
end

def calendar_params
  params.require(:calendar).permit(:title, :description)
end

def authenticate_admin!
  return if current_user&.admin?

  redirect_to root_path, alert: 'アクセス権限がありません'
end
