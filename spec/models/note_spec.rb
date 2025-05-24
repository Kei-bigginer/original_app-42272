require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @note = FactoryBot.build(:note)
  end

  describe 'ひとこと投稿の保存' do
    context '投稿できるとき' do
      it 'contentがあれば保存できる' do
        expect(@note).to be_valid
      end

      it 'contentが140文字ちょうどでも保存できる' do
        @note.content = 'あ' * 140
        expect(@note).to be_valid
      end
    end

    context '投稿できないとき' do
      it 'contentが空では保存できない' do
        @note.content = ''
        @note.valid?
        expect(@note.errors.full_messages).to include("Content を入力してください")
      end

      it 'contentが140文字を超えると保存できない' do
        @note.content = 'あ' * 141
        @note.valid?
        expect(@note.errors.full_messages).to include("Content は140文字以内で入力してください")
      end
    end
  end
end