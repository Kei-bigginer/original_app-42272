class CreateDiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :diaries do |t|
      t.references :user, null: false, foreign_key: true
    # t.references :pair, null: false, foreign_key: true
        # いつか必要になったらカラム追加予定※メモのため残し
      t.timestamps
    end
  end
end
