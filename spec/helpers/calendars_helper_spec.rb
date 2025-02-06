# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalendarsHelper, type: :helper do
  describe '#markdown_to_html' do
    it '普通のテキストを渡すとそのまま出力する' do
      expect(helper.markdown_to_html('Hello World')).to eq("<p>Hello World</p>\n")
    end

    it 'Markdownの見出しをHTMLに変換する' do
      expect(helper.markdown_to_html('# 見出し')).to eq("<h1>見出し</h1>\n")
    end
  end
end
