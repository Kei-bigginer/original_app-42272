FactoryBot.define do
  factory :note do
    content { "これはテスト用のひとこと投稿です。" }
    theme { "今日のありがとう" }
    association :user  # ユーザーと紐づけ
  end
end
