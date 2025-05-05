class MomentsController < ApplicationController
  before_action :authenticate_user!   # 🛡️ アクセス制限（ログインしてないと使えない）
  before_action :require_full_pair!   # 👥 ペアが2人揃っていないと使えない

  # 📄 一覧表示（自分とペアの記録）
  def index
    user_ids = current_user.pair.users.pluck(:id)     # 自分のペアに属するユーザーIDだけ取得
    @moments = Moment.where(user_id: user_ids).order(date: :desc)      # そのIDを持つ投稿だけ表示（新しい順）
  end

  # 📝 新規投稿ページを表示
  def new
    @moment = Moment.new
  end

  # 📥 フォーム送信 → 保存処理
  def create
    @moment = current_user.moments.new(moment_params)
    
    if @moment.save
      current_user.increment!(:trust_points, 5)        # ✅ 投稿成功したら、信頼ポイントを＋5加算
      redirect_to moments_path, notice: "記録を保存しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 🔐 ストロングパラメーター
  private

  def moment_params
    params.require(:moment).permit(:date, :memo, :location, :image)
  end
end
