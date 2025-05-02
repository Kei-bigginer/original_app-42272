FactoryBot.define do
  factory :note do
    content { "MyText" }
    user { nil }
    pair { nil }
  end
end
