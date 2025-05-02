class NotesController < ApplicationController



  def index
    # 📥 自分と同じペアのNote一覧を取得
    @notes = current_user.pair ? current_user.pair.users.includes(:notes).map(&:notes).flatten.sort_by(&:created_at).reverse : []
    @note = Note.new
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
