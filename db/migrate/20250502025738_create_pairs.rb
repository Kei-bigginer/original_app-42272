class CreatePairs < ActiveRecord::Migration[7.1]
  def change
    create_table :pairs do |t|

      t.date :anniversary       # オリジナルアプリ用：ふたりの記念日（未使用でも後で活用予定）
      t.string :invite_code, null: false # オリジナルアプリ用：ペア招待用のコード（必須項目）

      t.timestamps
    end
     # invite_code にインデックスを貼り、かつ重複登録を禁止（ユニーク制約）
     add_index :pairs, :invite_code, unique: true
  end
end
