# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#fallback_image_data' do
    it 'Stimulus用のdata属性を返す' do
      result = helper.fallback_image_data
      expect(result).to eq(
        controller: 'fallback-image',
        fallback_image_target: 'img',
        fallback_src: helper.asset_path('default_avatar.png')
      )
    end

    it 'フォールバック画像を指定した場合に正しく反映される' do
      result = helper.fallback_image_data(src: 'test_avatar1.png')
      expect(result[:fallback_src]).to eq(helper.asset_path('test_avatar1.png'))
    end
  end
end
