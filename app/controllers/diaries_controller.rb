class DiariesController < ApplicationController
   before_action :authenticate_user!  # 🔐 ログインユーザーでなければアクセス不可
   before_action :require_pair!    # 🛡️ ペア未所属ならリダイレクト（ApplicationControllerで定義済）

   # 📸 日常投稿一覧表示（自分のペアの投稿のみ）
   def index
     @diaries = Diary.where(pair_id: current_user.pair_id).order(created_at: :desc)
   end
 
   # 📥 新規投稿フォーム表示
   def new
     @diary = Diary.new
   end
 
   # 💾 投稿データを保存
   def create
     @diary = Diary.new(diary_params)
     @diary.user = current_user
     @diary.pair = current_user.pair
 
     if @diary.save
       redirect_to diaries_path, notice: "写真を投稿しました"
     else
       flash.now[:alert] = "投稿に失敗しました"
       render :new
     end
   end
 
   private
 
   # ✅ 許可されたパラメータのみ受け取る
   def diary_params
     params.require(:diary).permit(images: []) # ActiveStorageで複数枚対応
   end








end
