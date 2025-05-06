class NotesController < ApplicationController
  before_action :require_full_pair!

  def index
    @note = Note.new  # 投稿フォーム用の空インスタンス

    @notes = current_user.pair.users
                  .includes(:notes)            # N+1対策：Noteを事前に読み込み
                  .map(&:notes)                # 各ユーザーの投稿配列を取得
                  .flatten                     # ネスト配列をフラットに変換
                  .sort_by(&:created_at)       # 作成日時で昇順にソート
                  .reverse                     # 新しい順に並べ替え（全件表示）

    @theme = ["今日のありがとう", "相手に伝えたいこと", "今日うれしかったこと", "がんばったこと"].sample
    # ランダムで今日のテーマを1つ表示
  end

  def create
    # 制限は挙動確認のためコメントアウト
    # if posted_today?
    #   redirect_to notes_path, alert: "今日はすでに投稿済みです"
    #   return
    # end

    @note = current_user.notes.build(note_params)
    @note.theme = params[:note][:theme] || session[:today_theme] || "テーマ未設定"
    # 💡 フォームから送られてきたテーマを保存（未送信時はセッションor予備）

    if @note.save
      @notes = current_user.pair.users
                      .includes(:notes)
                      .flat_map(&:notes)
                      .sort_by(&:created_at)
                      .reverse      # ✅ 成功時：create.turbo_stream.erb を探して描画（モーダルを閉じるなど）

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to notes_path, notice: "投稿しました！" } # Fallback
      end
    else
      # ✅ 失敗時：バリデーションエラーをそのまま表示
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            "noteModal",  # ✅ モーダル本体のID
            partial: "notes/modal_form", # ✅ モーダル全体のテンプレートに変更
            locals: { note: @note, theme: @note.theme } # ✅ 必要な変数を渡す
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

  def note_params
    params.require(:note).permit(:content)
    # ※ themeはフォームで個別に代入するためpermitしない
  end

  def posted_today?
    current_user.notes.where(created_at: Time.zone.now.all_day).exists?
  end
end
