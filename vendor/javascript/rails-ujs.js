// vendor/javascript/rails-ujs.js

import * as Rails from "@rails/ujs"; // RailsのUJSライブラリをインポート
Rails.start(); // UJSを有効化（method: :delete などが使えるようになる）

window.Rails = Rails; // デバッグやグローバルアクセスのため（開発時便利）
