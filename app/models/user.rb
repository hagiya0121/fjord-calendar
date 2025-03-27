# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:github]

  enum :role, { user: 0, admin: 1 }

  validates :name, :provider_uid, presence: true
  validates :provider_uid, uniqueness: true

  has_many :entries, dependent: :destroy

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, provider_uid: auth.uid) do |user|
      user.name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end
end
