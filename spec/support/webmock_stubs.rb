# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

module WebMockStubs
  def stub_all_requests
    stub_ogp_entry
    stub_ogp_updated_entry
    stub_ogp_without_fallback
  end

  def stub_ogp_entry
    response = <<~HTML
      <html>
        <head>
          <meta property="og:title" content="リンクプレビューのタイトル">
          <meta property="og:description" content="リンクプレビューの説明">
          <meta property="og:image" content="http://example.com/og_image.png">
        </head>
      </html>
    HTML

    %i[head get].each do |method|
      stub_request(method, 'http://example.com')
        .to_return(status: 200, body: response, headers: { 'Content-Type' => 'text/html' })
    end

    stub_request(:head, 'http://invalid.example.com').to_raise(HTTP::ConnectionError)
  end

  def stub_ogp_updated_entry
    response = <<~HTML
      <html>
        <head>
          <meta property="og:title" content="更新されたリンクプレビューのタイトル">
          <meta property="og:description" content="更新されたリンクプレビューの説明">
          <meta property="og:image" content="http://example/updated_og_image.png">
        </head>
      </html>
    HTML

    %i[head get].each do |method|
      stub_request(method, 'http://example.com/updated')
        .to_return(status: 200, body: response, headers: { 'Content-Type' => 'text/html' })
    end
  end

  def stub_ogp_without_fallback
    response = <<~HTML
      <html>
        <head>
          <meta name="description" content="フォールバック時の説明">
          <title>フォールバック時のタイトル</title>
          <link rel="icon" href="http://example.com/favicon.png">
        </head>
      </html>
    HTML

    %i[head get].each do |method|
      stub_request(method, 'http://example.com/meta_without')
        .to_return(status: 200, body: response, headers: { 'Content-Type' => 'text/html' })
    end
  end
end

# rubocop:enable Metrics/MethodLength
