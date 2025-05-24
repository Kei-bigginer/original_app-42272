class DiariesController < ApplicationController
  before_action :authenticate_user!       # 🔐 ログインユーザーでなければアクセス不可
  before_action :require_full_pair!       # 👥 ペアが2人揃っていなければ制限

  # 📸 日常投稿一覧表示（自分のペアの投稿のみ）
  def index
    # ✅ モーダル用のフォームで使用する空のインスタンス
    @diary = Diary.new
  
    # ✅ 同じペアに所属するユーザーのID一覧を取得
    pair_user_ids = User.where(pair_id: current_user.pair_id).pluck(:id)
  
    # ✅ ペア全員の投稿を取得（新しい順に並べる）
    @diaries = Diary.where(user_id: pair_user_ids).order(created_at: :desc)
  end

  # 📥 新規投稿フォーム表示
  def new
    @diary = Diary.new
  end

 # 💾 投稿データを保存（＋信頼ポイント加算）
  def create
    @diary = Diary.new  # ← フォーム再描画用に仮のインスタンス

    # ✅ 画像が選択されていない場合はエラー処理へ
    if params[:diary][:images].blank?
      @diary.errors.add(:images, "を選択してください")
      @diaries = fetch_pair_diaries

      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "diaryModal-body",
            partial: "diaries/form",
            locals: { diary: @diary }
          )
        }
        format.html {
          flash[:alert] = "画像を選択してください"
          redirect_to diaries_path
        }
      end
      return
    end

    # ✅ 複数画像を1枚ずつ個別に投稿
    saved_count = 0
    params[:diary][:images].each do |image|
      diary = current_user.diaries.new
      diary.images.attach(image)
      saved_count += 1 if diary.save
    end

    # ✅ 投稿成功していたらポイント加算＆一覧取得
    if saved_count > 0
      current_user.increment!(:trust_points, saved_count)
      @diaries = fetch_pair_diaries

      respond_to do |format|
        format.turbo_stream  # → create.turbo_stream.erb が適用される
        format.html { redirect_to diaries_path, notice: "#{saved_count}枚の写真を投稿しました！" }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          @diary.errors.add(:base, "投稿に失敗しました")
          @diaries = fetch_pair_diaries
          render turbo_stream: turbo_stream.replace(
            "diaryModal-body",
            partial: "diaries/form",
            locals: { diary: @diary }
          )
        }
        format.html { redirect_to diaries_path, alert: "投稿に失敗しました" }
      end
    end
  end

  # 🔧 ペアユーザーの投稿を取得（一覧更新用）
  def fetch_pair_diaries
    pair_user_ids = User.where(pair_id: current_user.pair_id).pluck(:id)
    Diary.where(user_id: pair_user_ids).order(created_at: :desc)
  end


  private

  # ===============================
  # ✅ 許可されたパラメータのみ受け取る
  # ===============================
  def diary_params
    params.require(:diary).permit(images: []) # 📸 ActiveStorageで複数画像対応
  end
end
