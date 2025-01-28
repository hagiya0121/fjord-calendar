# frozen_string_literal: true

class Calendar < ApplicationRecord
  validates :title, :year, presence: true
  validates :year, uniqueness: true

  has_many :entries
end