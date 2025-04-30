# frozen_string_literal: true

calendar_description = <<~MARKDOWN
  ## これは何？🎄

  昨年に引き続き、20xx年もフィヨルドブートキャンプアドベントカレンダーをやります🎅
  フィヨルドブートキャンプの現役生・卒業生・メンター・アドバイザーが技術情報や日々の思いをアウトプットするアドベントカレンダーです。

  ## 参加資格👩‍👩‍👦‍👦

  - フィヨルドブートキャンプの現役生
  - フィヨルドブートキャンプの卒業生
  - フィヨルドブートキャンプメンター
  - フィヨルドブートキャンプアドバイザー

  つまり、フィヨルドブートキャンプにログイン出来る人全員です。

  ## 投稿テーマ🌟

  - フィヨルドブートキャンプで学んだ技術や個人的に取り組んでいる技術に関する記事（テック系）
  - フィヨルドブートキャンプの感想、思い出、発見、他の受講生に伝えたい思い（非テック系）
  - フィヨルドブートキャンプを卒業して感じていること（卒業生向け）
  - 卒業後も元気にやってます（卒業生向け）

  ...などなど、難しいことを書こうとする必要はありません。初歩的な技術情報でも全然ウェルカム、いつも書いてるブログ記事でも全然OKです。

  ## 参加方法🏃‍♀️

  自分が参加したい日にちを選んで参加登録してください！（早い者勝ち）
  原則は「1人＝1投稿」ですが、なかなか枠が埋まらなかったり、予定していた人が急に書けなくなったりした場合はピンチヒッターとして複数回投稿するのもアリです😁

  ## 記述媒体📝

  特に問いません。お好きなサービスを利用してください。

  - ブログ
  - note
  - Qiita
  - Zenn
  - Notion
  - Scrapbox
  - esaのpublic機能
  - gist
  - etc

  PodCast、Youtubeなど、テキスト以外のコンテンツでもWebからアクセスできるものであればOKですー

  ## お願い🙏

  記事の中にはアドベントカレンダーの投稿であることを冒頭でひとこと説明してください。

  ### 記述例

  ```
  これは「フィヨルドブートキャンプ Advent Calendar 2025」の5日目の記事です。
  https://fjord-calendar.com/calendars/2025
  ```

  自分が書いた記事をSNSにシェアするときは #fjordbootcamp のハッシュタグを付けてください。

  その他、不明な点があればフィヨルドブートキャンプのDiscordでお気軽にご質問ください。
MARKDOWN

if Rails.env.development?
  (2016..2026).each do |year|
    Calendar.find_or_create_by!(
      year: year,
      title: "フィヨルドブートキャンプ Advent Calendar #{year}",
      description: calendar_description
    )
  end

  (1..3).each do |i|
    User.find_or_create_by!(
      name: "テストユーザー_#{i}",
      provider: 'github',
      provider_uid: "test-user-#{i}",
      avatar_url: "/images/avatar_#{i}.png",
      role: 0
    )
  end

  def find_or_create_entry(user, calendar, day)
    user.entries.find_or_create_by!(
      calendar: calendar,
      registration_date: Date.new(calendar.year, 12, day),
      title: "記事タイトル_#{day}",
      meta_title: 'リンクプレビューのタイトル',
      meta_description: 'リンクプレビューの説明',
      meta_image_url: '/images/link_preview.png'
    )
  end

  user_1 = User.find_by!(provider_uid: 'test-user-1')
  user_2 = User.find_by!(provider_uid: 'test-user-2')
  user_3 = User.find_by!(provider_uid: 'test-user-3')

  calendar_2025 = Calendar.find_by!(year: 2025)
  (1..25).each do |day|
    find_or_create_entry(user_1, calendar_2025, day)
  end

  calendar_2024 = Calendar.find_by!(year: 2024)
  (1..25).each do |day|
    find_or_create_entry(user_1, calendar_2024, day)
    find_or_create_entry(user_2, calendar_2024, day)
  end

  calendar_2023 = Calendar.find_by!(year: 2023)
  (1..25).each do |day|
    find_or_create_entry(user_1, calendar_2023, day)
    find_or_create_entry(user_2, calendar_2023, day)
    find_or_create_entry(user_3, calendar_2023, day)
  end

  (2016..2022).each do |year|
    calendar = Calendar.find_by!(year: year)
    (1..25).each do |day|
      find_or_create_entry(user_1, calendar, day)
      find_or_create_entry(user_2, calendar, day)
    end
  end
end
