// 🚀 RailsのUJS（DELETEなどのlink_toに必要）
import Rails from "@rails/ujs"
Rails.start()

// ⚡ Turboリンクなど（Devise対応や画面遷移を速くする系）
import "@hotwired/turbo-rails"

// 🧠 Stimulus（後から拡張的に使うJS制御）
import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }
