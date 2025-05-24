class Diary < ApplicationRecord
  belongs_to :user

  # その時が来たら追加
  # belongs_to :pair　

  # 📷 画像を複数枚添付（ActiveStorage）
  has_many_attached :images
  # ✅ バリデーション：画像の添付必須（最低1枚）
  validate :images_presence
  # ✅ バリデーション：最大5枚までに制限
  validate :images_count_within_limit

  private

  # 🛡️ バリデーション：最低1枚は必須
  def images_presence
    errors.add(:images, "写真を1枚以上選んでください") unless images.attached?
  end

  # 🛡️ バリデーション：最大5枚まで
  def images_count_within_limit
    if images.attached? && images.count > 5
      errors.add(:images, "写真は最大5枚まで選択できます")
    end
  end
end
