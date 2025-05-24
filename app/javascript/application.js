// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// ✅ Rails UJS（method: :delete を動かす）の読み込み
import Rails from "@rails/ujs"
Rails.start() // ← ここで有効化！

// ✅ Turbo（ページ遷移を速くするライブラリ）
import "@hotwired/turbo-rails"

// ✅ Stimulus（JSでUI制御するライブラリ）
import "controllers"

// ✅ 自作ファイル（招待コードコピー処理）
import "./copy_invite_code"