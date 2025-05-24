# spec/factories/diaries.rb

FactoryBot.define do
  # Diaryモデル用のFactoryを定義
  factory :diary do
    # ユーザーとの関連をセット（user_idが必要なため）
    association :user

    # build（保存前）段階で画像ファイルを添付
    after(:build) do |diary|
      diary.images.attach(
        # 添付する画像ファイルのパスと情報を指定
        io: File.open(Rails.root.join('spec/fixtures/files/sample.jpg')), # テスト用の画像ファイル
        filename: 'sample.jpg',           # ファイル名（任意だが一致させると管理しやすい）
        content_type: 'image/jpeg'        # MIMEタイプ（JPEGを指定）
      )
    end
  end
end
