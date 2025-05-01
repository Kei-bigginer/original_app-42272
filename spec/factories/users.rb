FactoryBot.define do
  factory :user do
    nickname              { Faker::JapaneseMedia::OnePiece.character }  # → 日本語名がランダム生成される
    email                 { Faker::Internet.email }
    password              { "password123" }
    password_confirmation { password }
    birthday              { Faker::Date.birthday(min_age: 18, max_age: 65) }  # → 18〜65歳の誕生日
  end
end
