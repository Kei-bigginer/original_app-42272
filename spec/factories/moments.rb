# spec/factories/moments.rb

FactoryBot.define do
  factory :moment do
    association :user                              # ユーザーと紐づけ（必須）
    date { Date.today }                            # 今日の日付を自動で入れる
    memo { "楽しかったデートのメモ" }               # テスト用のメモ文

    # ✅ テスト用画像を添付（ActiveStorage用）
    after(:build) do |moment|
      moment.image.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/sample.jpg')),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
