# frozen_string_literal: true

module CalendarsHelper
  def markdown_to_html(text)
    Commonmarker.to_html(text)
  end
end
