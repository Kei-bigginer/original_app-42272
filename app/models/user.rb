class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

           # ユーザーは1つのペアに所属（まだ所属してなくてもOKなので optional: true）
         belongs_to :pair, optional: true
         # 🗒 ひとこと投稿（Note）を複数持つ
         has_many :notes, dependent: :destroy
         has_many :diaries, dependent: :destroy

         validates :nickname, presence: true, length: { maximum: 20 }
         validates :birthday, presence: true
        #  validates :trust_points, presence: true, 
        # numericality: { 
        #   only_integer: true, 
        #   greater_than_or_equal_to: 0 }
       



        

        end
