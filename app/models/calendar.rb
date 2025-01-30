# frozen_string_literal: true

class Calendar < ApplicationRecord
  before_validation :set_year

  validates :title, :year, presence: true
  validates :year, uniqueness: true

  has_many :entries, dependent: :destroy

  private

  def set_year
    self.year = Time.current.year
  end
end
