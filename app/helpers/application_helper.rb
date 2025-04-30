# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: 'Fjord Calendar',
      reverse: true,
      charset: 'utf-8',
      description: 'FjordCalendar はフィヨルドブートキャンプ専用の、アドベントカレンダーアプリです。',
      keywords: 'Fjord Bootcamp, アドベントカレンダー, プログラミング',
      separator: '|',
      og: og_tags,
      twitter: twitter_tags
    }
  end

  private

  def og_tags
    {
      title: :title,
      description: :description,
      url: request.original_url,
      image: image_url('og.png'),
      site_name: 'Fjord Calendar'
    }
  end

  def twitter_tags
    {
      title: :title,
      description: :description,
      card: 'summary_large_image',
      image: image_url('og.png'),
      url: request.original_url
    }
  end
end
