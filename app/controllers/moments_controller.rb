class MomentsController < ApplicationController

  # 📄 一覧表示（自分とペアの記録）
  def index
    # 自分のペアに属するユーザーIDだけ取得
    user_ids = current_user.pair.users.pluck(:id)
    # そのIDを持つ投稿だけ表示（新しい順）
    @moments = Moment.where(user_id: user_ids).order(date: :desc)
  end

  # 📝 新規投稿ページを表示
  def new
    @moment = Moment.new
  end

  # 📥 フォーム送信 → 保存処理
  def create
    @moment = current_user.moments.new(moment_params)
    if @moment.save
      redirect_to moments_path, notice: "記録を保存しました！"
    else
      render :new  # 保存失敗時は入力内容を保持したまま再表示
    end
  end

  # 🔐 ストロングパラメーター
  private

  def moment_params
    params.require(:moment).permit(:date, :memo, :location, :image)
  end
end
