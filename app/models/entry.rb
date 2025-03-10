# frozen_string_literal: true

class Entry < ApplicationRecord
  validates :title, :registration_date, presence: true
  validate :url_valid

  belongs_to :user
  belongs_to :calendar

  before_save :fetch_meta_info

  def previous_entry
    Entry.where(calendar_id: calendar_id, registration_date: ...registration_date)
         .order(registration_date: :desc)
         .take
  end

  private

  def url_valid
    return if url.blank?

    unless url.match?(/\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/)
      errors.add(:url, 'は http または https で始まるURLを入力してください')
      return
    end

    begin
      HTTP.headers('User-Agent' => 'Mozilla/5.0').head(url)
    rescue HTTP::ConnectionError
      errors.add(:url, 'にアクセスできません')
    end
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
