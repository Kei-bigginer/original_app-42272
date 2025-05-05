FactoryBot.define do
  factory :moment do
    date { "2025-05-05" }
    memo { "MyText" }
    location { "MyString" }
    user { nil }
  end
end
