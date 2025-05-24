class ApplicationController < ActionController::Base
    # ✅ 共通Beforeアクション
  before_action :authenticate_user!
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?


    # Deviseログイン後の遷移先# 
    # ペアが存在すれば root_path（TOPへ）、
  # なければ ペア作成ページへ誘導
    def after_sign_in_path_for(resource)
      resource.pair.present? ? root_path : new_pair_path # ← 任意のパスに変更できる！
    end

  # 🛡️ ペア未所属ガード（共通化しておく）
  # 機能ページなどで「ペアがないと使えない」場合に使用
  # 各Controllerで before_action :require_pair! で使える
  def require_pair!
    unless current_user.pair
      redirect_to new_pair_path, alert: "ペアを作成または参加してください"
    end
  end

 # 🛡️ ペアが2人そろっていないガード
  # → ペアは存在しているが、相手が未参加の場合に使用
  # 各Controllerで before_action :require_full_pair! で使える
  def require_full_pair!
    if current_user.pair.nil? || current_user.pair.users.count < 2
      redirect_to new_pair_path, alert: "ふたりのペアが揃っていません"
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
