# frozen_string_literal: true

module CalendarsHelper
  def markdown_to_html(text)
    converted_html = Commonmarker.to_html(text, options: { extension: { header_ids: nil } })
    raw(converted_html) # rubocop:disable Rails/OutputSafety
  end
end
