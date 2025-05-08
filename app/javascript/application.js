// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// import "@rails/ujs"         // ✅ Importmap用に読み込む

// Rails.start()               // ✅ Rails UJSを有効化する

// ✅ JavaScriptモジュールの読み込み（自作ファイルをインポート）
import "./copy_invite_code"
