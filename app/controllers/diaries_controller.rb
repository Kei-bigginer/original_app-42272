class DiariesController < ApplicationController
  before_action :authenticate_user!       # 🔐 ログインユーザーでなければアクセス不可
  before_action :require_full_pair!       # 👥 ペアが2人揃っていなければ制限

  # 📸 日常投稿一覧表示（自分のペアの投稿のみ）
  def index
    # 💡 現在のユーザーと同じペアに属するユーザーの投稿を取得（ペアIDカラムがないためユーザーの関連で絞る）
    pair_user_ids = User.where(pair_id: current_user.pair_id).pluck(:id)
    @diaries = Diary.where(user_id: pair_user_ids).order(created_at: :desc)
  end

  # 📥 新規投稿フォーム表示
  def new
    @diary = Diary.new
  end

  # 💾 投稿データを保存（＋信頼ポイント加算）
  def create
    @diary = current_user.diaries.build(diary_params)

    if @diary.save
      # ✅ 添付画像の枚数ぶん信頼ポイントを加算（画像がない場合は0加算）
      image_count = @diary.images.count
      current_user.increment!(:trust_points, image_count) if image_count > 0

      redirect_to diaries_path, notice: "投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # ===============================
  # ✅ 許可されたパラメータのみ受け取る
  # ===============================
  def diary_params
    params.require(:diary).permit(images: []) # 📸 ActiveStorageで複数画像対応
  end
end
