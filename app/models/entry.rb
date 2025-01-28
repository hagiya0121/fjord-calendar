# frozen_string_literal: true

class Entry < ApplicationRecord
  validates :title, :registration_date, presence: true

  belongs_to :user
  belongs_to :calendar
end
