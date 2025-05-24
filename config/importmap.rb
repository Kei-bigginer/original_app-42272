# Pin npm packages by running ./bin/importmap


pin "application"
pin "@rails/ujs", to: "@rails--ujs.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "copy_invite_code"
pin "expand-image_controller", to: "controllers/expand-image_controller.js"
