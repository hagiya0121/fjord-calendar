# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: 'Fjord Calendar',
      reverse: true,
      charset: 'utf-8',
      description: 'Fjord Bootcampのアドベントカレンダーを作成・閲覧できるサービスです。',
      keywords: 'Fjord Bootcamp, アドベントカレンダー, プログラミング',
      separator: '|',
      og: {
        title: :title,
        description: :description,
        url: request.original_url,
        image: image_url('og_image.png')
      }
    }
  end
end
