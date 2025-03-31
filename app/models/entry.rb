# frozen_string_literal: true

class Entry < ApplicationRecord
  validates :title, :registration_date, presence: true
  validate :validate_url

  belongs_to :user
  belongs_to :calendar

  before_save :fetch_meta_info

  def previous_entry
    Entry.where(calendar_id: calendar_id, registration_date: ...registration_date)
         .order(:registration_date)
         .last
  end

  private

  def validate_url
    return if url.blank?

    unless url_format_valid?
      errors.add(:url, 'の形式が不正です')
      return
    end

    errors.add(:url, 'にアクセスできません') unless url_accessible?
  end

  def url_format_valid?
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def url_accessible?
    response = HTTP.headers('User-Agent' => 'Mozilla/5.0').head(url)
    response.status.success?
  rescue HTTP::ConnectionError
    false
  end

  def fetch_meta_info
    return if url.blank?

    html = HTTP.headers('User-Agent' => 'Mozilla/5.0').get(url).to_s
    doc = Nokogiri::HTML(html)
    self.meta_title = doc.at('meta[property="og:title"]')&.attr('content') ||
                      doc.at('title')&.text
    self.meta_description = doc.at('meta[property="og:description"]')&.attr('content') ||
                            doc.at('meta[name="description"]')&.attr('content')
    self.meta_image_url = doc.at('meta[property="og:image"]')&.attr('content') ||
                          doc.at('link[rel="icon"]')&.attr('href')
  end
end
