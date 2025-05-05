class Moment < ApplicationRecord
  
    # 🔗 アソシエーション
belongs_to :user                     # 🙋 投稿者（Userに属する）
  has_one_attached :image              # 🖼️ 画像を1枚添付できる（ActiveStorage）


    # ✅ バリデーション（保存条件）
  validates :date, presence: true      # 📅 デート日は必須
  validates :memo, presence: true      # ✏️ メモも必須
  validates :image, presence: true     # 🖼️ 画像も必須（添付されてないと保存NG）

    # 🛑 未来日を許可しない
    validate :date_cannot_be_in_future

    private

  # 📆 今日より後の日付は登録できないようにする
  def date_cannot_be_in_future
    if date.present? && date > Date.today
      errors.add(:date, "は今日以前の日付を選んでください")
    end
  end

  
end
