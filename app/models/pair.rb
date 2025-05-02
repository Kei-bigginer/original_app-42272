class Pair < ApplicationRecord

   # アソシエーション
   has_many :users

   # バリデーション：invite_code は必須＆重複禁止
   validates :invite_code, presence: true, uniqueness: true

    # ✅ 保存前にコード生成
  #  before_create :generate_invite_code 
   before_validation :generate_invite_code, on: :create

   private

   def generate_invite_code
    return if invite_code.present? # すでにある場合はスキップ

    loop do
      code = SecureRandom.alphanumeric(8)
      unless Pair.exists?(invite_code: code)
        self.invite_code = code
        break
      end
    end
  end

end
