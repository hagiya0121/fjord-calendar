# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, :rememberable, omniauth_providers: [:github]

  enum :role, { user: 0, admin: 1 }

  validates :name, :provider_uid, presence: true
  validates :provider_uid, uniqueness: { scope: :provider }

  has_many :entries, dependent: :destroy

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, provider_uid: auth.uid) do |user|
      user.name = auth.info.name.presence || 'Anonymous'
      user.avatar_url = auth.info.image.presence || '/assets/default_avatar.png'
    end
  end
end
