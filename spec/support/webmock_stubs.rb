# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

module WebMockStubs
  def stub_example_com
    body = <<~HTML
      <html>
        <head>
          <meta property="og:title" content="Mocked Title">
          <meta property="og:description" content="Mocked Description">
          <meta property="og:image" content="http://example.com/mock-image.jpg">
          <title>Example Page</title>
        </head>
        <body>
          <h1>Hello</h1>
        </body>
      </html>
    HTML

    example_urls = %w[
      http://example.com
      http://example.com/updated
    ]

    example_urls.each do |url|
      stub_request(:head, url).to_return(status: 200, body: '', headers: { 'Content-Type' => 'text/html' })
      stub_request(:get, url).to_return(status: 200, body: body, headers: { 'Content-Type' => 'text/html' })
    end

    stub_request(:head, 'http://invalid.example.com/').to_raise(HTTP::ConnectionError)
  end
end

# rubocop:enable Metrics/MethodLength
