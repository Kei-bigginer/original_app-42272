require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OriginalApp42272
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

     # ✅ 日本語をデフォルトロケールに設定
     config.i18n.default_locale = :ja

     # ✅ タイムゾーンを東京に設定（日本時間で表示・保存）
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
     
    # ✅ ActiveStorageで画像処理にmini_magickを使用
    config.active_storage.variant_processor = :mini_magick

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
