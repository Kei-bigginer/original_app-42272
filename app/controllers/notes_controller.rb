class NotesController < ApplicationController
  before_action :require_pair!



  def index
    # 💬 投稿フォーム用の空インスタンスを用意
    # フォームで使用するため（form_with model: @note）
    @note = Note.new
    # 📥 ペア内の投稿一覧を取得（最新順）
    # ※ current_user.pair が nil（まだペア未作成）の場合は空配列で対応
    if current_user.pair
      # ペアに所属するユーザー2人のNoteをまとめて取得し、作成日で新しい順に並べる
      @notes = current_user.pair.users
                  .includes(:notes)                       # N+1問題を防ぐため事前にNoteも一緒に取得
                  .map(&:notes)                           # 各ユーザーの投稿（Note）を配列にする
                  .flatten                                # [[note1, note2], [note3]] → [note1, note2, note3]
                  .sort_by(&:created_at).reverse          # 作成日時が新しい順に並び替え
    else
      @notes = []  # ペアが存在しない場合は空配列
    end
  
    # ================================
    # 🎲 毎日のランダムテーマを表示（例：「今日のありがとう」など）
    # ※ 今後は時間帯・季節などに応じて出し分け予定
    # ================================
    @theme = ["今日のありがとう", "相手に伝えたいこと", "今日うれしかったこと", "がんばったこと"].sample
  end
  

  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      redirect_to notes_path, notice: 'ひとことを投稿しました！'
    else
      @notes = current_user.pair ? current_user.pair.users.includes(:notes).map(&:notes).flatten.sort_by(&:created_at).reverse : []
      render :index, alert: '投稿に失敗しました'
    end
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end

end
