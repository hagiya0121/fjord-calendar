# frozen_string_literal: true

class Calendar < ApplicationRecord
  validates :title, :year, presence: true
  validates :year, uniqueness: true

  has_many :entries, dependent: :destroy

  def max_entries
    (entries.count / 25) + 1
  end

  def start_date
    Date.new(year, 12, 1)
  end
end
