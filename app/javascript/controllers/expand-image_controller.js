import { Controller } from "@hotwired/stimulus"

// 📸 画像クリックで拡大モーダルを表示するコントローラー
export default class ExpandImageController extends Controller {
  // StimulusのValue機能を使って、画像URLを受け取る
  static values = { url: String }

  // ✅ Stimulusコントローラーが読み込まれたときに一度だけ実行される
  connect() {
    const modal = document.getElementById("imageModal")
    if (modal) {
      // Bootstrapの「モーダルが表示される直前」にaria-hiddenを遅延削除（タイミングによる警告対策）
      modal.addEventListener("show.bs.modal", () => {
        setTimeout(() => {
          modal.removeAttribute("aria-hidden") // 🔥 アクセシビリティ警告を確実に防ぐための遅延処理
        }, 10)
      })

      // 表示完了時にも念のため再チェック（念押し）
      modal.addEventListener("shown.bs.modal", () => {
        modal.removeAttribute("aria-hidden")
      })
    }
  }

  // ✅ 画像がクリックされたときに呼ばれるアクション
  show() {
    const modalImage = document.getElementById("modalImage")
    if (modalImage) {
      // モーダルに表示する画像をセット
      modalImage.src = this.urlValue

      // フォーカスを画像以外に一時的に飛ばす（アクセシビリティ対応）
      document.activeElement.blur()
    }
  }
}
