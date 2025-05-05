# spec/models/diary_spec.rb

require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe '日常投稿（画像投稿）' do
    before do
      # 有効なDiaryインスタンスを作成（FactoryBotを使用）
      @diary = FactoryBot.build(:diary)
    end

    context '投稿できるとき' do
      it '画像が1枚以上あれば保存できる' do
        # バリデーションが通ることを確認（trueが返る）
        expect(@diary).to be_valid
      end
    end

    context '投稿できないとき' do
      it '画像が添付されていないと保存できない' do
        # imagesを空にする
        @diary.images = []

        # バリデーションに失敗することを確認
        @diary.valid?

        # エラーメッセージに「画像が必要」と含まれているかチェック
        expect(@diary.errors.full_messages).to include('Images 写真を1枚以上選んでください')
        # ↑↑ ここは実際のエラーメッセージに合わせて書き換えてOK！
      end

      it '画像が6枚以上だと保存できない' do
        # 同じ画像を6枚添付する（上限5枚までの想定）
        6.times do
          @diary.images.attach(
            io: File.open(Rails.root.join('spec/fixtures/files/sample.jpg')),
            filename: 'sample.jpg',
            content_type: 'image/jpeg'
          )
        end

        @diary.valid?
        expect(@diary.errors.full_messages).to include('Images 写真は最大5枚まで選択できます')
        # ↑↑ 上限エラーの内容に合わせて書き換えてOK！
      end
    end
  end
end
