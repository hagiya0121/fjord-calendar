# frozen_string_literal: true

class Calendar < ApplicationRecord
  validates :title, :year, presence: true
  validates :year, uniqueness: true

  has_many :entries, dependent: :destroy

  def entry_on?(date)
    entries.exists?(registration_date: date)
  end
end
