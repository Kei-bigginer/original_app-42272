// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import ExpandImageController from "./expand-image_controller" // 👈 明示的に読み込む

application.register("expand-image", ExpandImageController)   // 👈 名前と紐づけ
