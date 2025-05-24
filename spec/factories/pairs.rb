FactoryBot.define do
  factory :pair do
    # ✅ anniversary は任意のため適当な日付をセット（なくても通る）
    anniversary { "2025-05-01" }

    # ✅ invite_code は自動生成されるので明示的には書かない（モデル内で生成されるため）
  end
end
