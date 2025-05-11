class PairsController < ApplicationController
  before_action :require_full_pair!, only: :index

  def index
    @note = Note.new  # 投稿フォーム用インスタンス
    @trust_points = current_user.trust_points  # 自分の信頼ポイント
    # 自分の直近3投稿
    @my_recent_notes = current_user.notes.order(created_at: :desc).limit(3)
    # 相手ユーザーを取得（ペアの中で current_user じゃない方）
    partner = current_user.pair.users.where.not(id: current_user.id).first
    # 相手の直近3投稿（相手が存在する場合のみ）
    @partner_recent_notes = partner.present? ? partner.notes.order(created_at: :desc).limit(3) : []
  
    # ↓ これを入れてなかったらエラーになる
    @recent_notes = (@my_recent_notes + @partner_recent_notes).sort_by(&:created_at).reverse.first(3)

     # 🖼 Swiper用：自分と相手の画像投稿を取得（最新ランダム10件）
    pair_user_ids = current_user.pair.users.pluck(:id) # 👈 ペアの全ユーザーID
    if ActiveRecord::Base.connection.adapter_name == "Mysql2"
      # 🐬 開発環境（MySQL）の場合：RAND()を使用
      @diaries = Diary.includes(images_attachments: :blob).where(user_id: pair_user_ids).order("RAND()").limit(10)
    else
      # 🐘 本番環境（PostgreSQL）の場合：RANDOM()を使用
      @diaries = Diary.includes(images_attachments: :blob).where(user_id: pair_user_ids).order("RANDOM()").limit(10)
    end
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

  

end
