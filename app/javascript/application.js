// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// ✅ Rails UJS（リンクに method: :delete を効かせる）を読み込む
import * as Rails from "@rails/ujs"
Rails.start()

// ✅ Turbo（ページ遷移を速くするライブラリ）
import "@hotwired/turbo-rails"

// ✅ Stimulus（JSでUI制御するライブラリ）
import "controllers"

// ✅ 自作ファイル（招待コードコピー処理）
import "./copy_invite_code"