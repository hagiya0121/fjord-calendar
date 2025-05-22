# frozen_string_literal: true

class Entry < ApplicationRecord
  validates :registration_date, presence: true
  validates :url, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/, message: 'の形式が不正です' },
                  allow_blank: true

  belongs_to :user
  belongs_to :calendar

  def previous_entry
    Entry.where.not(id: id)
         .where(calendar_id: calendar_id, registration_date: ..registration_date)
         .order(:registration_date, created_at: :asc)
         .last
  end

  def update_meta_info
    return if url.blank?

    html = fetch_html
    meta_info = extract_meta_info(html)
    update(meta_info)
  rescue HTTP::Error, Addressable::URI::InvalidURIError
    update(
      meta_title: '無効なURLです',
      meta_description: nil,
      meta_image_url: nil
    )
  end

  private

  def fetch_html
    HTTP.headers('User-Agent' => 'Mozilla/5.0').get(url).to_s
  end

  def extract_meta_info(html) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    doc = Nokogiri::HTML(html)

    {
      meta_title: doc.at('meta[property="og:title"]')&.attr('content') ||
        doc.at('title')&.text,
      meta_description: doc.at('meta[property="og:description"]')&.attr('content') ||
        doc.at('meta[name="description"]')&.attr('content'),
      meta_image_url: doc.at('meta[property="og:image"]')&.attr('content') ||
        doc.at('link[rel="icon"]')&.attr('href')
    }
  end
end
