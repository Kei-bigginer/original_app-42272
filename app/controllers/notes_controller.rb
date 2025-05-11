class NotesController < ApplicationController
  before_action :require_full_pair!

  # 🎲 今日のテーマ一覧（定数化）
  THEMES = [
    "今日のありがとう",
    "相手に伝えたいこと",
    "今日うれしかったこと",
    "がんばったこと",
    "今、感じていること",
    "今日の発見",
    "小さな幸せ",
    "ちょっとした後悔",
    "相手の良いところ",
    "未来のふたりへのひとこと"
  ]

  def index
    # ✅ 投稿フォーム用の空インスタンス
    @note = Note.new

    # ✅ ペア全体の投稿一覧（N+1対策＋時系列降順）
    @notes = current_user.pair.users
                  .includes(:notes)
                  .map(&:notes)
                  .flatten
                  .sort_by(&:created_at)
                  .reverse

    # ✅ 今日のテーマを10個の中からランダムで1つ出す
    @theme = THEMES.sample
  end

  def create
    # ✅ 制限（1日1投稿）は現在OFF：必要なら復活させる
    # if posted_today?
    #   redirect_to notes_path, alert: "今日はすでに投稿済みです"
    #   return
    # end

    # ✅ フォームからの投稿データを取得
    @note = current_user.notes.build(note_params)

    # ✅ テーマはフォーム or セッション or デフォルトのどれか
    @note.theme = params[:note][:theme] || session[:today_theme] || "テーマ未設定"

    if @note.save
      # ✅ 保存成功時、全投稿を再取得（Turbo対応）
      @notes = current_user.pair.users
                      .includes(:notes)
                      .flat_map(&:notes)
                      .sort_by(&:created_at)
                      .reverse

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to notes_path, notice: "投稿しました！" }
      end
    else
      # ✅ 保存失敗時、モーダルごと再描画（バリデ対応）
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "noteModal",
            partial: "notes/modal_form",
            locals: { note: @note, theme: @note.theme }
          )
        }
        format.html {
          flash.now[:alert] = "投稿に失敗しました。"
          render :index
        }
      end
    end
  end

  private

  # ✅ content のみ許可（themeは手動で代入）
  def note_params
    params.require(:note).permit(:content)
  end

  # ✅ 1日1回の投稿制限を確認（現在未使用）
  def posted_today?
    current_user.notes.where(created_at: Time.zone.now.all_day).exists?
  end
end
