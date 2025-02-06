# frozen_string_literal: true

module SimpleCalendarHelper
  def start_weekday(year)
    Date.new(year, 12, 1).cwday - 1
  end

  def advent_dates(year)
    Date.new(year, 12, 1)..Date.new(year, 12, 25)
  end

  def today_class(day)
    day == Time.zone.today ? 'bg-yellow-100' : ''
  end
end
