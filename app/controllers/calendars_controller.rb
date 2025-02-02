# frozen_string_literal: true

class CalendarsController < ApplicationController
  def show
    @calendar = Calendar.find(params[:id])
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(calendar_params)

    if @calendar.save
      redirect_to @calendar, notice: 'カレンダーが作成されました'
    else
      render :new, status: :unprocessable_entity
    end
  end
end

private

def calendar_params
  params.require(:calendar).permit(:title, :description)
end
