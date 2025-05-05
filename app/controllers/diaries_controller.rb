class DiariesController < ApplicationController
   before_action :authenticate_user!  # 🔐 ログインユーザーでなければアクセス不可
   before_action :require_full_pair!

   # 📸 日常投稿一覧表示（自分のペアの投稿のみ）
   def index
    # 💡 現在のユーザーと同じペアに属するユーザーの投稿を取得（ペアIDカラムがないためユーザーの関連で絞る）
    pair_user_ids = User.where(pair_id: current_user.pair_id).pluck(:id) # 👈 同じペアのuser_idを配列で取得
    @diaries = Diary.where(user_id: pair_user_ids).order(created_at: :desc) # 👈 取得したuser_idに一致する投稿のみ取得
  end
 
   # 📥 新規投稿フォーム表示
   def new
    @diary = Diary.new # 💡 新規投稿用のインスタンス
   end
 
   # 💾 投稿データを保存
   def create
    @diary = current_user.diaries.build(diary_params) # 💡 投稿者（current_user）に紐づけて作成
    if @diary.save
      redirect_to diaries_path, notice: "投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
   end
 
   private
 
   # ✅ 許可されたパラメータのみ受け取る
   def diary_params
     params.require(:diary).permit(images: []) # ActiveStorageで複数枚対応
   end








end
