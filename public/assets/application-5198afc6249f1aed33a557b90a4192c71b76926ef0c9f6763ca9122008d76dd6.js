// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import * as Rails from "@rails/ujs"  // ← `Rails` を明示的に定義

Rails.start()               // ✅ Rails UJSを有効化する

// ✅ JavaScriptモジュールの読み込み（自作ファイルをインポート）
import "./copy_invite_code";
