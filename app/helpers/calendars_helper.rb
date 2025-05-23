# frozen_string_literal: true

module CalendarsHelper
  MAX_CALENDAR_AVATARS = 11

  def max_calendar_avatars
    MAX_CALENDAR_AVATARS
  end

  def markdown_to_html(text)
    converted_html = Commonmarker.to_html(text, options: { extension: { header_ids: nil } })
    raw(converted_html) # rubocop:disable Rails/OutputSafety
  end
end
