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
          <meta property="og:image" content="test_og_image.png">
        </head>
      </html>
    HTML

    stub_request(:get, 'http://example.com')
      .to_return(status: 200, body: response, headers: { 'Content-Type' => 'text/html' })

    stub_request(:get, 'http://invalid.example.com').to_raise(HTTP::ConnectionError)
  end

  def stub_ogp_updated_entry
    response = <<~HTML
      <html>
        <head>
          <meta property="og:title" content="更新されたリンクプレビューのタイトル">
          <meta property="og:description" content="更新されたリンクプレビューの説明">
          <meta property="og:image" content="test_updated_og_image.png">
        </head>
      </html>
    HTML

    stub_request(:get, 'http://example.com/updated')
      .to_return(status: 200, body: response, headers: { 'Content-Type' => 'text/html' })
  end

  def stub_ogp_without_fallback
    response = <<~HTML
      <html>
        <head>
          <meta name="description" content="フォールバック時の説明">
          <title>フォールバック時のタイトル</title>
          <link rel="icon" href="test_favicon.png">
        </head>
      </html>
    HTML

    stub_request(:get, 'http://example.com/meta_without')
      .to_return(status: 200, body: response, headers: { 'Content-Type' => 'text/html' })
  end
end

# rubocop:enable Metrics/MethodLength
