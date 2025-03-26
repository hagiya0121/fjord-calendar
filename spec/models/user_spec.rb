# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '12345',
        info: {
          name: 'テストユーザー',
          image: 'http://example.com/avatar1.png'
        }
      )
    end

    context '該当ユーザーが存在しない場合' do
      it '新しいユーザーが作成される' do
        expect { described_class.from_omniauth(auth) }.to change(described_class, :count).by(1)
      end

      it '正しい属性がセットされる' do
        user = described_class.from_omniauth(auth)
        expect(user.name).to eq('テストユーザー')
        expect(user.avatar_url).to eq('http://example.com/avatar1.png')
        expect(user.provider).to eq('github')
        expect(user.provider_uid).to eq('12345')
      end
    end

    context '該当ユーザーが存在する場合' do
      it '既存のユーザーを返す' do
        existing_user = create(:user, provider: 'github', provider_uid: '12345')
        expect do
          user = described_class.from_omniauth(auth)
          expect(user).to eq(existing_user)
        end.not_to change(described_class, :count)
      end
    end
  end
end
