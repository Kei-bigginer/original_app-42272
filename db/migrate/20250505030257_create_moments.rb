class CreateMoments < ActiveRecord::Migration[7.1]
  def change
    create_table :moments do |t|
      t.date :date, null: false           # 📅 デート日
      t.text :memo, null: false           # ✏️ メモ（必須）
      t.string :location                  # 📍 場所（任意）
      t.references :user, null: false, foreign_key: true  # 🙋 投稿者（必須）

      t.timestamps
    end
  end
end
