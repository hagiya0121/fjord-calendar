# frozen_string_literal: true

class Entry < ApplicationRecord
  validates :title, :registration_date, presence: true

  belongs_to :user
  belongs_to :calendar

  before_validation :fetch_meta_info

  private

  def fetch_meta_info
    return if url.blank?

    html = HTTP.headers('User-Agent' => 'Mozilla/5.0').get(url).to_s
    doc = Nokogiri::HTML(html)

    self.meta_title = doc.at('meta[property="og:title"]')&.attr('content')
    self.meta_description = doc.at('meta[property="og:description"]')&.attr('content') || '/images/avatar1.png'
    self.meta_image_url = doc.at('meta[property="og:image"]')&.attr('content')
  end
end
