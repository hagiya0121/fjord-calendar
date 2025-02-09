# frozen_string_literal: true

class User < ApplicationRecord
  enum :role, { user: 0, admin: 1 }

  validates :name, :provider_uid, presence: true
  validates :provider_uid, uniqueness: true

  has_many :entries, dependent: :destroy
end
