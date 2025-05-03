class Diary < ApplicationRecord
  belongs_to :user

  # その時が来たら追加
  # belongs_to :pair　

  has_many_attached :images  # ✅ 複数画像投稿に対応する設定

end
