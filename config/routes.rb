Rails.application.routes.draw do
  devise_for :users     # Deviseによるユーザー認証ルーティング
  root to: "pairs#index"     # トップページをペア一覧（index）に設定
  post "pairs/join", to: "pairs#join", as: "join_pairs" # POSTリクエストで招待コード参加を処理する独自アクション


  resources :pairs, only: [:index, :new, :create ] # ペア関連で使うルートを制限して定義（RESTfulに最小限）
  
  
  resources :notes, only: [:index, :new, :create ]   # 🗒 Note機能（投稿・表示だけでOK）
  resources :diaries, only: [:index, :new, :create ]
  resources :moments, only: [:index, :new, :create ]

end
