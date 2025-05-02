class PairsController < ApplicationController
  before_action :require_full_pair, only: :index

  def index
  # トップページ表示処理（仮でもOK）
  end


  def new
    # @pairがnilの時だけ新しくインスタンスを作る（再描画時にデータ保持できるように）
    @pair ||= Pair.new
  end

  def create
     # すでにペアに所属してるなら作成NG
  if current_user.pair.present?
    flash[:alert] = "すでにペアに参加済みです。ペア作成はできません。"
    redirect_to new_pair_path and return
  end

    @pair = Pair.new(pair_params) 
    if @pair.save
      # 作成されたペアにcurrent_userを紐づける（1人目の参加者になる）
      current_user.update(pair_id:@pair.id) # ✅ ユーザーにペアを紐づけ！
      # ペア作成直後の画面にそのままflashを表示（リダイレクトせずに使う）
      flash.now[:notice] = "ペアを作成しました！"
      render :new # ←ここでそのまま new.html.erb を再表示
    else
      # バリデーションエラーなどで作成できなかった場合の処理
      render :new, status: :unprocessable_entity
    end
  end


  # 招待コードでペアに参加するアクション
  def join
        # 入力された招待コードでペアを検索
    pair = Pair.find_by(invite_code: params[:invite_code])

    if pair.nil?
      # 該当するペアがなければエラー表示
      flash[:alert] = "招待コードが正しくありません"
    elsif pair.users.count >= 2
      # すでに2人参加済みなら弾く（ペア制限）
      flash[:alert] = "このペアにはすでに2人参加しています"
    else
      # 無事に参加できる場合、ユーザーにペアを紐づける
      current_user.update(pair: pair)
      flash[:notice] = "ペアに参加しました！"
    end
      # 成否に関わらずリダイレクト（ビュー表示はしない）
    redirect_to root_path
  end

  private

  def pair_params
    params.require(:pair).permit(:anniversary)
  end

    # ✅ ペア未所属 or 2人未満のときはペア作成ページにリダイレクト
  def require_full_pair
    if current_user.pair.nil? || current_user.pair.users.count < 2
      flash[:alert] = "ふたりのペアが揃うまでトップページには進めません"
      redirect_to new_pair_path
    end
  end


end
