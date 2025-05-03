class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?


    # Deviseログイン後の遷移先
    def after_sign_in_path_for(resource)
      resource.pair.present? ? root_path : new_pair_path # ← 任意のパスに変更できる！
    end

# ==================================
  # 🛡️ ペア未所属ガード（共通化しておく）
  # 機能ページなどで「ペアがないと使えない」場合に使用
  # 各Controllerで before_action :require_pair! で使える
  # ==================================
  def require_pair!
    unless current_user.pair
      redirect_to new_pair_path, alert: "ペアを作成または参加してください"
    end
  end




  private

    # 🔐 Basic認証：外部から呼ばれない内部処理
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  # 🛠 Deviseで追加パラメータを許可（nickname, birthday）
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :birthday])
  end

end
