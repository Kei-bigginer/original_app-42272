// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as Rails from "@rails/ujs"  // ← `Rails` を明示的に定義
Rails.start()               // ✅ Rails UJSを有効化する

import "@hotwired/turbo-rails"
import "controllers"
import "./copy_invite_code" // ✅ JavaScriptモジュールの読み込み（自作ファイルをインポート）

