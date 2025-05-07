# FjordCalendar
![og](https://github.com/user-attachments/assets/4afa6a2b-8753-423c-a9c1-486d312bdc0e)
<br>
<br>

## 概要

FjordCalendar はフィヨルドブートキャンプ（以下、FBC）専用の、アドベントカレンダーアプリです。  

#### 特徴

- FBC のメンバー限定で記事を投稿できます
- カレンダーの同じ日に複数人が登録可能です
- ブログ記事のリンクを Markdown 形式で出力できます
<br>
<br>

## URL

https://fjord-calendar.jp  
<br>
  
## 機能

### カレンダーの作成・編集（管理者のみ）
![calendar_new](https://github.com/user-attachments/assets/75669d6a-7aa8-40f5-813e-b30f10a7d19e)
<br>
<br>

### カレンダーから記事を登録
![entry_new](https://github.com/user-attachments/assets/7d0d597f-8e14-49ab-92a8-efd33fe1f1dc)
<br>
<br>

### カレンダーの同じ日に複数人が登録可能
![calendar](https://github.com/user-attachments/assets/58d0ff20-cd16-49ea-a820-33451587c0b0)
<br>
<br>

### マイページから過去に登録した記事を見る
![my_page](https://github.com/user-attachments/assets/afecde37-b722-4bb3-b0c5-a1295eea3ab9)
<br>
<br>

## 動作環境

- Ruby 3.3.7
- Ruby on Rails 7.2.2
- Hotwire
<br>

## 開発環境

- セットアップ

```
$ git clone https://github.com/hagiya0121/fjord-calendar.git
$ cd fjord-calendar
$ bin/setup
```

- 起動

```
$ bin/dev
```
<br>

## Lint/Test

- Lint

```
$ bin/lint
```

- Test

```
$ bundle exec rspec
```


