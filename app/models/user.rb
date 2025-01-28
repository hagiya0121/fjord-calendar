# frozen_string_literal: true

class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }

  validates :name, :provider_uid, presence: true
  validates uniqueness: true

  has_many :entries
end
