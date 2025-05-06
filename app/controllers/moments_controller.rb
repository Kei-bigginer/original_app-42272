class MomentsController < ApplicationController
  before_action :authenticate_user!   # 🛡️ アクセス制限（ログインしてないと使えない）
  before_action :require_full_pair!   # 👥 ペアが2人揃っていないと使えない

  # 📄 一覧表示（自分とペアの記録）
  def index
    user_ids = current_user.pair.users.pluck(:id)     # 自分のペアに属するユーザーIDだけ取得
    @moments = Moment.where(user_id: user_ids).order(date: :desc)      # そのIDを持つ投稿だけ表示（新しい順）
    @moment = Moment.new  # ✅ モーダルフォーム用に空インスタンスを用意
  end

  # 📥 フォーム送信 → 保存処理
  def create
    @moment = current_user.moments.new(moment_params)

    if @moment.save
      current_user.increment!(:trust_points, 5)  # ✅ 信頼ポイント＋5

      # ✅ Turbo用：最新一覧取得（ペア全体）
      user_ids = current_user.pair.users.pluck(:id)
      @moments = Moment.where(user_id: user_ids).order(date: :desc)

      respond_to do |format|
        format.turbo_stream  # → create.turbo_stream.erb を呼び出す
        format.html { redirect_to moments_path, notice: "記録を保存しました！" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "momentModal-body",
            partial: "moments/form",
            locals: { moment: @moment }
          )
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # 🔐 ストロングパラメーター
  private

  def moment_params
    params.require(:moment).permit(:date, :memo, :location, :image)
  end
end
