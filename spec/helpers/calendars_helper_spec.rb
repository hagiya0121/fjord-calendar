# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalendarsHelper, type: :helper do
  describe '#markdown_to_html' do
    it '普通のテキストを渡すとそのまま出力する' do
      html = helper.markdown_to_html('Hello World')
      expect(html).to eq("<p>Hello World</p>\n")
    end

    it '見出しをHTMLに変換する' do
      markdown = '# 見出し'
      html = helper.markdown_to_html(markdown)
      expect(html).to include('<h1>見出し</h1>')
    end

    it 'リストをHTMLに変換する' do
      markdown = "- リスト1\n- リスト2"
      html = helper.markdown_to_html(markdown)
      expect(html).to include("<ul>\n<li>リスト1</li>\n<li>リスト2</li>\n</ul>\n")
    end

    it 'チェックボックスをHTMLに変換する' do
      markdown = "- [ ] 未完了\n- [x] 完了"
      html = helper.markdown_to_html(markdown)
      expect(html).to include('<input type="checkbox" disabled="" /> 未完了')
      expect(html).to include('<input type="checkbox" checked="" disabled="" /> 完了')
    end

    it 'テーブルをHTMLに変換する' do
      markdown = "| A | B | C |\n|---|---|---|\n| 1 | 2 | 3 |"
      html = helper.markdown_to_html(markdown)
      expect(html).to include('<table>')
      expect(html).to include('<th>A</th>')
      expect(html).to include('<td>1</td>')
    end

    it '強調をHTMLに変換する' do
      markdown = '*イタリック* **ボールド** ~~取り消し線~~'
      html = helper.markdown_to_html(markdown)
      expect(html).to include('<em>イタリック</em>')
      expect(html).to include('<strong>ボールド</strong>')
      expect(html).to include('<del>取り消し線</del>')
    end

    it 'リンクをHTMLに変換する' do
      markdown = '[Google](https://www.google.com)'
      html = helper.markdown_to_html(markdown)
      expect(html).to include('<a href="https://www.google.com">Google</a>')
    end
  end
end
