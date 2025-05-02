class Pair < ApplicationRecord

   # アソシエーション
   has_many :users

   # バリデーション：invite_code は必須＆重複禁止
   validates :invite_code, presence: true, uniqueness: true

end
