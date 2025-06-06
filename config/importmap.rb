# Pin npm packages by running ./bin/importmap


pin "application"

# 📦 importmapで Rails UJS を読み込めるようにする設定
# 👉 CDN経由で @rails/ujs を読み込む（安定版のURL指定）
# config/importmap.rb
# pin "@rails/ujs", to: "https://cdn.jsdelivr.net/npm/@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "copy_invite_code"
pin "expand-image_controller", to: "controllers/expand-image_controller.js"
