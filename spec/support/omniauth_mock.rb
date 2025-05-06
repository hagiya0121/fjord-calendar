# frozen_string_literal: true

module OmniAuthMock
  def mock_github_auth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new({
                               provider: 'github',
                               uid: '12345',
                               info: {
                                 nickname: 'テストユーザー',
                                 image: 'https://example.com/avatar1.png'
                               }
                             })
  end

  def mock_github_auth_failure
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
  end

  def mock_github_auth_invalid
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new({
                               provider: 'github',
                               uid: nil,
                               info: {
                                 nickname: 'テストユーザー',
                                 image: 'https://example.com/avatar1.png'
                               }
                             })
  end
end
