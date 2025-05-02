Rails.application.routes.draw do
    # Deviseによるユーザー認証ルーティング
  devise_for :users
    # トップページをペア一覧（index）に設定
  root to: "pairs#index"
# POSTリクエストで招待コード参加を処理する独自アクション
post "pairs/join", to: "pairs#join", as: "join_pairs"
  
# ペア関連で使うルートを制限して定義（RESTfulに最小限）
  resources :pairs, only: [:index, :new, :create ]



  
end
