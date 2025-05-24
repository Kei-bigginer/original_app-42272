class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 # 🔗 アソシエーション

  # ユーザーは1つのペアに所属（まだ所属してなくてもOKなので optional: true）
  belongs_to :pair, optional: true
  # 🗒 ひとこと投稿（Note）を複数持つ
  has_many :notes, dependent: :destroy
  # 📷 日常投稿（Diary）を複数持つ
  has_many :diaries, dependent: :destroy
  # 💑 デート記録（Moment）を複数持つ
  has_many :moments, dependent: :destroy

  # ✅ バリデーション
  # ニックネーム：必須＆20文字以内
  validates :nickname, presence: true, length: { maximum: 20 }
  # 誕生日：必須
  validates :birthday, presence: true
  # 誕生日：未来日は不可
  validate :birthday_cannot_be_in_the_future

  # 🛠 カスタムバリデーション定義
  def birthday_cannot_be_in_the_future
    if birthday.present? && birthday > Date.today
      errors.add(:birthday, "は今日以前の日付を選んでください")
    end
  end

  # ============================== #
  # 📝 trust_pointsのバリデーション（必要時に解放）
  # ============================== #
  # validates :trust_points, presence: true,
  #           numericality: {
  #             only_integer: true,
  #             greater_than_or_equal_to: 0
  #           }
end